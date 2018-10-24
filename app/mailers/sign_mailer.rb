class SignMailer < ApplicationMailer
  def by_campaigner(sign, title, body)
    @sign = sign
    @body = body
    @unsubscribe = Rails.application.message_verifier(:unsubscribe).generate(@sign.id)
    mail(to: sign.signer_email, subject: title,
      template_name: "by_campaigner") if sign.signer_email
  end
end
