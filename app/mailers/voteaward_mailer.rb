class VoteawardMailer < ApplicationMailer
  def email_confirmation user
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "투표대잔치 2018 리부트 안내")
  end
end
