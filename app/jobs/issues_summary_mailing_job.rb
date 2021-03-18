class IssuesSummaryMailingJob
  include Sidekiq::Worker
  sidekiq_options lock: :while_executing, lock_timeout: 0, on_conflict: :raise, retry: 8

  def perform
    User.need_to_delivery_issues_summary_mailing.limit(300).each do |user|
      summary(user)
    end
  end

  def summary(user)
    SummaryMailer.for_issues(user).deliver_now
  rescue => e
    logger.error e.message
    e.backtrace.each { |line| logger.error line }
  end
end

