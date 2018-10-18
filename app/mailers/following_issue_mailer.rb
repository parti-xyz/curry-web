class FollowingIssueMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.following_issue_mailer.notify.subject
  #
  def notify user, issue, campaign
    @user = user
    @issue = issue
    @campaign = campaign
    mail(to: user.email, subject: "관심 이슈에 대한 새로운 프로젝트 알림",
      template_name: "notify")
  end
end
