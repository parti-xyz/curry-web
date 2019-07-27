class Voteaward::User < ActiveRecord::Base
  self.table_name = 'voteaward_users'

  def email_activate
    self.email_confirmed = true
    self.email_confirmed_at = Time.now
    self.confirm_token = nil
    save!(validate: false)
  end

  def reset_confirmation
    self.email_confirmed = false
    self.email_confirmed_at = nil
    self.confirm_token = nil
    save!(validate: false)
  end

  def confirmation_token
    self.confirm_token = SecureRandom.urlsafe_base64.to_s if self.confirm_token.blank?
    save!(validate: false)
  end
end
