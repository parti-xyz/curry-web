class SignMailer < ApplicationMailer
  def by_campaigner(sign, title, body)
    @sign = sign
    @body = body
    @unsubscribe = Rails.application.message_verifier(:unsubscribe).generate(@sign.id)
    if sign.email_sendable?
      mail(to: sign.user_email, subject: title, template_name: "by_campaigner")
    end
  end
end
