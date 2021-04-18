class Api::V1::CampaignsController < ApplicationController

  def signs_recent
    campaign = Campaign.find(params[:id])
    signs = campaign.signs.order('id desc').take(8).map{ |x| { signer_name: x.user_name, body: x.body, signed_at: x.created_at, sign_count: campaign.signs.where('id <= ?', x).count } }
    render json: signs
  end

  private

  def campaigns_params
    params.require(:cmapaign).permit(:id)
  end
end