class Comment < ApplicationRecord
  include Likable
  include Choosable
  include Reportable

  include ActionView::Helpers::TextHelper
  include SmartTextHelper

  extend Enumerize
  enumerize :mailing, in: %i(disable ready sent fail)

  acts_as_taggable # Alias for acts_as_taggable_on :tags

  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :user
  belongs_to :target_agent, optional: true, class_name: 'Agent'
  has_many :orders, dependent: :destroy
  has_many :target_agents, through: :orders, source: :agent
  has_many :comments, as: :commentable, dependent: :destroy

  mount_uploader :image, ImageUploader

  scope :recent, -> { order(created_at: :desc) }
  scope :earlier, -> { order(created_at: :asc) }
  scope :with_target_agent, ->(agent) { joins(:target_agents).where('orders.agent_id = ?', agent.id) }


  validates :body, presence: true
  validates :commenter_email, format: { with: Devise.email_regexp, message: :need_to_valid_email }, if: proc { commenter_email.present? }
  validate :commenter_should_be_present_if_user_is_blank
  validate :photo_and_map_campaign_should_check_image_attachment
  validates_acceptance_of :confirm_privacy

  before_validation :strip_whitespace
  after_validation :fetch_geocode, if: ->(obj){ obj.full_street_address.present? and obj.full_street_address_changed? }

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

  def init_gps_by_image(gps)
    return if gps.blank?
    self.latitude = gps.latitude
    self.longitude = gps.longitude
  end

  def fetch_geocode
    self.latitude = nil
    self.longitude = nil
    begin
      response = RestClient.get "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=#{CGI.escape(self.full_street_address)}", 'X-NCP-APIGW-API-KEY-ID': ENV["NAVER_CLIENT_ID"], 'X-NCP-APIGW-API-KEY': ENV["NAVER_CLIENT_SECRET"]
      return unless response.code == 200

      data = JSON.parse(response.body)
      return if data.blank?
      address = data["addresses"].try(:first)
      return if address.blank?

      self.longitude = address["x"]
      self.latitude = address["y"]
    rescue
    end
  end

  def smart_body(htmlable = true)
    if htmlable
      self.is_html_body ? self.body : smart_format(self.body)
    else
      self.is_html_body ? Html2Text.convert(self.body) : self.body
    end
  end

  private

  def commenter_should_be_present_if_user_is_blank
    if user.blank? and commenter_name.blank?
      errors.add(:commenter_name, I18n.t('activerecord.errors.models.comment.commenter.blank'))
    end
  end

  def photo_and_map_campaign_should_check_image_attachment
    if %w(photo map).include? commentable.try(:template) and
        (self.persisted? ? read_attribute(:image).blank? : !self.image?)
      errors.add(:image, '을(를) 선택하세요')
    end
  end

  def strip_whitespace
    self.commenter_email = self.commenter_email.strip unless self.commenter_email.blank?
  end
end
