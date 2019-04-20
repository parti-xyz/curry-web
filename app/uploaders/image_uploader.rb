# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def self.env_storage
    if Rails.env.production?
      :fog
    else
      :file
    end
  end

  storage env_storage

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    model_folder_name = model.class.to_s.underscore.gsub /^deprecated_/, ''
    "uploads/#{model_folder_name}/#{mounted_as}/#{model.id}"
  end

  def content_type_whitelist
    /image\//
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  version :xs  do
    process resize_to_fit: [80, nil]
  end

  version :sm do
    process resize_to_fit: [200, nil]
  end

  version :md do
    process resize_to_fit: [400, nil]
  end

  version :lg do
    process resize_to_fit: [700, nil]
  end

  def default_url
    ActionController::Base.helpers.asset_path('default-image.png')
  end

  # def url(version = nil)
  #   super_result = super(version)
  #   if Rails.env.production?
  #     super_result
  #   elsif self.file.try(:exists?)
  #     if ImageUploader::env_storage == :fog
  #       super_result
  #     else
  #       super_result = "http://#{ENV["HOST"]}#{super_result}" if ENV["HOST"].present?
  #       super_result
  #     end
  #   else
  #     if ImageUploader::env_storage == :fog
  #       "https://curry-file.s3.amazonaws.com#{self.path}"
  #     else
  #       "https://curry-file.s3.amazonaws.com#{super_result}"
  #     end
  #   end
  # end

  def url(version = nil)
    super_result = super(version)

    if Rails.env.production?
      return super_result
    elsif self.model.read_attribute(self.mounted_as.to_sym).blank?
      super_result
    else
      if self.file.try(:exists?) or ENV["S3_BUCKET"].blank?
        ActionController::Base.helpers.asset_url(super_result)
      else
        "https://#{ENV["S3_BUCKET"]}.s3.amazonaws.com#{super_result}"
      end
    end
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  def url(*args)
    super_result = super(args)
    if Rails.env.production? or self.file.nil?
      super_result
    elsif self.file.try(:exists?)
      if ImageUploader::env_storage == :fog
        super_result
      else
        super_result = "https://#{ENV["HOST"]}#{super_result}" if ENV["HOST"].present?
        super_result
      end
    else
      if ImageUploader::env_storage == :fog
        "https://curry-file.s3.amazonaws.com#{self.path}"
      else
        "https://curry-file.s3.amazonaws.com#{super_result}"
      end
    end
  end

  def fix_exif_rotation
    manipulate! do |img|
      img.tap(&:auto_orient)
    end
  end
  process :fix_exif_rotation

  def store_gps
    if image?(self.file) and model.present? and model.respond_to?(:"init_gps_by_#{mounted_as}")
      begin
        gps = EXIFR::JPEG.new(self.file.file).gps
        model.send(:"init_gps_by_#{mounted_as}", gps) if gps.present?
      rescue EXIFR::MalformedJPEG => e
      end
    end
  end
  process :store_gps

  protected

  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end

  def image?(new_file)
    return false unless new_file.present?
    new_file.content_type.try(:start_with?, 'image')
  end
end
