class Admin::AgentsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @agents = Agent.page(params[:page]).per(100)
    @agents = @agents.search_for(params[:q]) if params[:q].present?
    @agents = @agents.joins(:positions).merge(Position.named(params[:position])) if params[:position].present?
  end

  def create
    if @agent.save
      redirect_to admin_agents_path
    else
      render 'new'
    end
  end

  def update
    if @agent.update(agent_params)
      redirect_back(fallback_location: admin_agents_path)
    else
      render 'edit'
    end
  end

  def resign_position
    @agent.appointments.of_positions_named(params[:position_name]).destroy_all
    redirect_back(fallback_location: admin_agents_path)
  end

  def destroy
    @agent.destroy
    redirect_back(fallback_location: admin_agents_path)
  end

  private

  def agent_params
    params.require(:agent).permit(:image, :name, :organization, :category, :position_name_list, :email, :twitter, :public_site, :election_region)
  end
end
