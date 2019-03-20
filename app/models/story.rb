class Story < ApplicationRecord
  include Likable

  belongs_to :user
  belongs_to :storiable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy

  mount_uploader :cover, ImageUploader

  scope :recent, -> { order('published_at DESC').order('id DESC') }
  scope :by_organization, ->(organization) { where(storiable: organization.projects) }

  validates :title, presence: true
  VALID_PUBLISHED_AT_REGEX = /\A\d{4}-\d{2}-\d{2}/

  validates :published_at,
    presence: true,
    format: { with: VALID_PUBLISHED_AT_REGEX, message: :need_yyyy_mm_dd }

  def fallback_social_image_url
    if self.read_attribute(:cover).present?
      self.cover_url
    else
      self.storiable.try(:social_image_url)
    end
  end
end
