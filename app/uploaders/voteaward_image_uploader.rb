# encoding: utf-8

class VoteawardImageUploader < ImageUploader
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.oid}" #mongodb object id
  end

  def default_url
    ActionController::Base.helpers.asset_path('logo-voteaward.png')
  end
end
