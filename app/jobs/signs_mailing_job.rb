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
        SignMailer.by_campaigner(sign, title, body).deliver_later if sign.subscribed
      end
    end
  end
end
