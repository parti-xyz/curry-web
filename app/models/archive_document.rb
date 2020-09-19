class ArchiveDocument < ApplicationRecord
  acts_as_taggable

  BULK_META = %i(id title body content_creator content_created_date
    content_created_time content_source donor is_secret_donor
    content_recipients media_type
    remote_content_url category_slug tag_list)

  extend Enumerize
  enumerize :media_type, in: %i(문서 사진 도면 영상 음성)

  before_save :update_content_attributes

  belongs_to :user
  belongs_to :archive
  belongs_to :category, class_name: 'ArchiveCategory', optional: true, primary_key: :slug, foreign_key: :category_slug
  has_many :comments, as: :commentable
  has_one :clypit, dependent: :destroy
  has_one :sewol_inv_document, dependent: :nullify, class_name: 'Archive::SewolInvDocument'
  has_one :additional, class_name: 'NposAddtionalArchiveDocument'
  accepts_nested_attributes_for :additional

  attr_accessor :google_access_token

  mount_uploader :content, PrivateFileUploader

  validates :title, presence: true
  validates :body, presence: true
  validates :category_slug, presence: true

  default_scope { order('content_created_date DESC, content_created_time DESC, created_at DESC, id DESC') }
  scope :recent, -> { order('id DESC') }
  scoped_search on: [:title]

  def original_filename_attribute
    :content_name
  end

  def has_content?
    read_attribute(:content).present?
  end

  def image?
    content_type.try(:start_with?, 'image')
  end

  def valid_name
    return false if content_name.blank?
    self.content_name.gsub(/\\+/, "%20")
  end

  def parse_content_created_date
    return [nil, nil, nil] if content_created_date.blank?

    year = content_created_date[0..3]
    month = content_created_date[4..5]
    day = content_created_date[6..7]

    [year, (month if month != "00"), (day if day != "00")]
  end

  # bulk

  def self.bulk_attributes
    BULK_META
  end

  def self.bulk_human_attribute_names
    BULK_META.map { |a| human_attribute_name(a) }
  end

  def self.bulk_human_attribute_helps
    BULK_META.map { |a| I18n.t("messages.xlsx_help.archive_document.#{a}", default: "") }
  end

  def self.bulk_attribute_index(attribute)
    BULK_META.index(attribute.to_sym)
  end

  def before_process_bulk(bulk_task)
    self.archive = bulk_task.archive
    self.google_access_token = bulk_task.google_access_token
    self.user = bulk_task.user
  end

  def process_bulk_of_is_secret_donor(value)
    if value == "예"
      self.is_secret_donor = true
    else
      self.is_secret_donor = false
    end
  end

  def process_bulk_of_remote_content_url(value)
    return if value.blank?

    begin
      google_file = google_drive_session.file_by_url(value)
    rescue GoogleDrive::Error
      self.remote_content_url = value
      return
    end

    Tempfile.open(['archive', File.extname(google_file.title)]) do |temp_file|
      google_file.download_to_file(temp_file.path)

      self.content = temp_file.open
      self.content_name = google_file.title
    end
  end

  def human_formatted_content_created_datetime
    year, month, day = parse_content_created_date
    "#{[year.try('+', '.'), month.try('+', '.'), day.try('+', '.')].compact.join('')} #{content_created_time}".try(:strip)
  end

  def human_formatted_donor
    "#{is_secret_donor ? '비공개' : donor}"
  end

  private

  def update_content_attributes
    if read_attribute(:content).present? && content_changed?
      self.content_type = content.file.content_type
      self.content_size = content.file.size
    end
  end
end
