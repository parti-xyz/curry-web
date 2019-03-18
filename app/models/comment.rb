class Comment < ApplicationRecord
  include Likable
  include Choosable
  include Reportable

  extend Enumerize
  enumerize :mailing, in: %i(disable ready sent fail)

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  geocoded_by :full_street_address

  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :user
  belongs_to :target_agent, optional: true, class_name: Agent
  has_many :target_agents, through: :orders, source: :agent
  has_many :orders, dependent: :destroy

  mount_uploader :image, ImageUploader

  scope :recent, -> { order(created_at: :desc) }
  scope :earlier, -> { order(created_at: :asc) }
  scope :with_target_agent, ->(agent) { joins(:target_agents).where('orders.agent_id = ?', agent.id) }

  validates :body, presence: true
  validates :commenter_email, format: { with: Devise.email_regexp }, if: 'commenter_email.present?'
  validate :commenter_should_be_present_if_user_is_blank
  after_validation :fetch_geocode, if: ->(obj){ obj.full_street_address.present? and obj.full_street_address_changed? }

  before_save :save_gps

  attr_accessor :target_agent_id

  def user_nickname
    user.present? ? user.nickname : commenter_name
  end

  def user_email
    user.present? ? user.email : commenter_email
  end

  def user_image
    user.present? ? user.image : 'default-user.png'
  end

  def target_agents_to_s
    self.target_agents.map{ |agent| "#{agent.organization} #{agent.name}" }.join(", ")
  end

  def user_order_seq
    return if self.orders.empty?

    first_comment = commentable.comments
      .where('orders_count > 0')
      .where(user_id: user_id)
      .where(commenter_name: commenter_name)
      .where(commenter_email: commenter_email).first
    commentable.comments
      .where("id <= ?", first_comment.id)
      .where('orders_count > 0')
      .select(:user_id, :commenter_name, :commenter_email)
      .distinct.size
  end

  private

  def save_gps
    begin
      if self.image.present? and self.full_street_address.blank?
        gps = EXIFR::JPEG.new(self.image.file.path).gps
        if gps.present?
          self.latitude = gps.latitude
          self.longitude = gps.longitude
        end
      end
    rescue EXIFR::MalformedJPEG => e
    end
  end

  def commenter_should_be_present_if_user_is_blank
    if user.blank? and commenter_name.blank?
      errors.add(:commenter_name, I18n.t('activerecord.errors.models.comment.commenter.blank'))
    end
  end

  def fetch_geocode
    self.latitude = nil
    self.longitude = nil
    geocode
  end
end
