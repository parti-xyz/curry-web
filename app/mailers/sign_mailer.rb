class SignMailer < ApplicationMailer
  def by_campaigner(sign, title, body)
    @sign = sign
    @body = body
    mail(to: sign.user_email, subject: title,
      template_name: "by_campaigner")
  end
end
