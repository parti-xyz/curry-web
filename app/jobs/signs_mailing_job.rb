class SignsMailingJob
  include Sidekiq::Worker
  def perform(campaign_id, title, body, preview_email, user_id)
    @campaign = Campaign.find_by(id: campaign_id)
    return if @campaign.blank?
    if preview_email.present?
      user = User.find_by(id: user_id)
      return if user.blank?
      sign = Sign.new(user: user, body: "test", signer_name: user.nickname, signer_email: preview_email, campaign: @campaign)
      SignMailer.by_campaigner(sign, title, body).deliver_now
    else
      @campaign.signs.each do |sign|
        subscription = EmailSubscription.find_by(email: sign.signer_email, mailerable: @campaign) || EmailSubscription.create!(email: sign.signer_email, use: true, mailerable: @campaign)
        SignMailer.by_campaigner(sign, title, body).deliver_later if subscription.use
      end
    end
  end
end
