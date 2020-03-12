class Sign < ApplicationRecord
  include Reportable

  belongs_to :user, optional: true
  belongs_to :campaign, counter_cache: true

  validates :user, uniqueness: { scope: :campaign }, if: 'user.present?'
  validate :valid_signer
  validates_acceptance_of :confirm_privacy
  validates_presence_of :confirm_third_party
  validate :valid_signer
  validates :signer_email, format: { with: Devise.email_regexp }, uniqueness: { scope: :campaign }, if: 'signer_email.present?'

  scope :recent, -> { order(created_at: :desc) }
  scope :earlier, -> { order(created_at: :asc) }

  def user_image_url
    user.present? ? user.image.sm.url : ActionController::Base.helpers.asset_path('default-user.png')
  end

  def user_name
    signer_real_name.presence || (user.present? ? user.nickname : signer_name)
  end

  def user_email
    user.present? ? user.email : signer_email
  end

  def email_sendable?
    self.user_email.present? and self.subscribed?
  end

  private

  def valid_signer
    if campaign.use_signer_real_name?
      if signer_real_name.blank?
        errors.add(:signer_real_name, I18n.t('errors.messages.blank'))
      end
    else
      if user.blank? and signer_name.blank?
        errors.add(:signer_name, I18n.t('errors.messages.blank'))
      end
    end

    if campaign.use_signer_email? and signer_email.blank?
      errors.add(:signer_email, I18n.t('errors.messages.blank'))
    end

    if campaign.use_signer_address.required? and signer_address.blank?
      errors.add(:signer_address, I18n.t('errors.messages.blank'))
    end
  end
end
