class AgenciesController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
  end

  def show
    @campaigns = @agency.related_campaigns
    @form_campaign = Campaign.new(special_slug: Special::SLUG_VOTEAWARD2018)
  end

  def agents
    @all_agents = @agency.agents
    if params[:position_name]
      @agents = @agency.agents.of_position_names(params[:position_name]).order(:name)
    else
      @agents = @agency.agents.order(:name)
    end
    @agents = @agents.page(params[:page])
  end
end
