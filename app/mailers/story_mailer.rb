class StoryMailer < ApplicationMailer
  def for_campaign(campaign, story, email_subscription)
    @campaign = campaign
    @story = story
    @email_subscription = email_subscription

    @unsubscribe_url = unsubscribe_url(id: Rails.application.message_verifier(:unsubscribe).generate(@email_subscription.id), title: @campaign.title, link: campaign_url(@campaign))

    if @email_subscription.use?
      mail(to: email_subscription.email, subject: "[빠띠 캠페인즈] #{story.title}", template_name: "for_campaign")
    end
  end
end
