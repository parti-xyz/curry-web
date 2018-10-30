class SignMailerPreview < ActionMailer::Preview
  def by_campaigner
    SignMailer.by_campaigner(Sign.last || Sign.new, "test", "email test")
  end
end
