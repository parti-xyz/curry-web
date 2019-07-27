# Preview all emails at http://localhost:3000/rails/mailers/voteaward_mailer
class VoteawardMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/voteaward_mailer/email_confirmation
  def email_confirmation
    # VoteawardMailer.email_confirmation
    VoteawardMailer.email_confirmation Voteaward::User.find(2)
  end

end
