class AgentsController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:position_name]
      @agents = Agent.of_position_names(params[:position_name]).order(:name)
    else
      @agents = Agent.order(:name)
    end
  end

  def search
    respond_to do |format|
      if params[:q].present?
        @searched_agents = Agent.search_for(params[:q])
        @searched_agencies = Agency.where('title like ?', "%#{params[:q]}%")
      end
      format.json
      format.html
    end
  end

  def show
    @agendas = Agenda.where(id: AgendasIssue.where(issue: Issue.where(id: @agent.opinions.select(:issue_id))).select(:agenda_id).distinct)
    if params[:agenda_id].present?
      @agenda = Agenda.find params[:agenda_id]
      respond_to do |format|
        format.js { render 'agents/show_agenda' }
        format.html
      end
    end
  end

  def create_access_token
    if @agent.refresh_access_token != params[:refresh_access_token]
      flash[:error] = '재설정 요청한지 오래되었거나 잘못된 요청입니다'
      redirect_to root_url and return
    end
    @agent.clear_refresh_access_token
    @agent.generate_access_token
    unless @agent.save
      error_to_flash(@agent)
      redirect_to root_url and return
    end
  end

  def new_access_token
    @agent.generate_refresh_access_token
    @agent.save
    AgentMailer.refresh_access_token(@agent.id).deliver_later
  end
end
