class StoriesMailingJob
  include Sidekiq::Worker

  def perform(story_id)
    story = Story.find_by(id: story_id)
    return if story.blank?
    return if story.storiable_type != 'Campaign'

    return if story.mailed_at.present?

    campaign = story.storiable

    ActiveRecord::Base.transaction do
      email_data = campaign.comments.where(confirm_privacy: true).where.not(commenter_email: nil).where.not(commenter_email: EmailSubscription.where(mailerable: campaign).select(:email)).pluck(:commenter_name, :commenter_email)

      email_data += User.where(id: campaign.comments.select(:user_id)).where.not(email: nil).where.not(email: EmailSubscription.where(mailerable: campaign).select(:email)).pluck(:nickname, :email)

      email_data += campaign.signs.where(confirm_privacy: true).where.not(signer_email: nil).where.not(signer_email: EmailSubscription.where(mailerable: campaign).select(:email)).pluck(:signer_name, :signer_email)

      email_data += User.where(id: campaign.signs.select(:user_id)).where.not(email: nil).where.not(email: EmailSubscription.where(mailerable: campaign).select(:email)).pluck(:nickname, :email)

      email_data.group_by{ |data| data[1] }.map{ |email, data| (data.find { |item| item[0].present? } || [ nil, email]) }.each do |data|
        campaign.email_subscriptions.create(name: data[0], email: data[1], use: true)
      end

      EmailSubscription.where(mailerable: campaign).where(use: true).find_each do |email_subscription|
        StoryMailer.for_campaign(campaign, story, email_subscription).deliver_later
      end

      story.update_columns(mailed_at: Time.now)
    end
  end
end
