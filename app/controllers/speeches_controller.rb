class SpeechesController < ApplicationController
  load_and_authorize_resource

  def index
    @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
    if params[:event_id]
      @campaign = Campaign.find_by(previous_event_id: params[:event_id])
      render_404 and return if @campaign.blank?
      redirect_to speeches_path(campaign_id: @campaign.id)
      return
    end
    @speeches = Speech.all.recent.page params[:page]
  end

  def new
    @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
  end

  def create
    @speech.user = current_user
    if @speech.save
      redirect_to @speech.campaign
    else
      render 'new'
    end
  end

  private
  def speech_params
    params.require(:speech).permit(:title, :video_url, :campaign_id)
  end
end
