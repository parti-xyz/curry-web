class SignMailer < ApplicationMailer
  def by_campaigner(sign, title, body)
    @sign = sign
    @body = body
    @unsubscribe = Rails.application.message_verifier(:unsubscribe).generate(@sign.signer_email)
    mail(to: sign.signer_email, subject: title,
      template_name: "by_campaigner")
  end
end
