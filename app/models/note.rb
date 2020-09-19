class Note < ApplicationRecord
  include Likable
  include Choosable
  include Reportable

  belongs_to :opinion
  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }
  scope :earlier, -> { order(created_at: :asc) }

  validates :body, presence: true
  validates :writer_email, format: { with: Devise.email_regexp }, if: proc { writer_email.present? }
  validate :writer_should_be_present_if_user_is_blank

  def user_nickname
    user.present? ? user.nickname : writer_name
  end

  def user_image
    user.present? ? user.image : User.new.image
  end

  private

  def writer_should_be_present_if_user_is_blank
    if user.blank? and writer_name.blank?
      errors.add(:writer_name, I18n.t('activerecord.errors.models.comment.writer.blank'))
    end
  end
end
