  class SummaryMailer < ApplicationMailer
  layout 'new_mailer'

  after_action :delivered_user_issues_summary_mailing, only: :for_issues

  def for_issues(user)
    @user = user

    return unless @user.enable_mailing?

    need_to_mailings = IssueMailing.where(issue: @user.following_issues.pluck(:issue_id))
      .after(@user.datetime_of_need_to_issues_summary_mailing).before(1.days.ago.at_end_of_day)
    return if need_to_mailings.empty?

    need_to_mailings.to_a
      .group_by { |issue_mailing| issue_mailing.source_type }
      .each do |source_type, issue_mailings|
        instance_variable_set("@#{source_type.underscore.pluralize}", issue_mailings.map(&:source))
      end

    subject = ['[빠띠 캠페인즈] 이번 주엔 어떤 소식이 올라왔을까요?',
      '[빠띠 캠페인즈] 이 주엔 어떤 일들이 있었는지 확인하세요.',
      '[빠띠 캠페인즈] 어떤 이야기들이 나오고 있을까요?',
      '[빠띠 캠페인즈] 잘지내시나요? 빠띠 캠페인즈 이야기들을 전합니다.',
      '[빠띠 캠페인즈] 이번 주 이야기들이 도착했습니다!'].sample

    mail(to: @user.email, subject: "#{I18n.l Date.today} #{subject}")
  end

  private

  def delivered_user_issues_summary_mailing
    return if !@user.try(:enable_mailing?)
    @user.try(:issues_summary_mailing_delivered!)
  end
end
