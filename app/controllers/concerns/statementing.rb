module Statementing
  extend ActiveSupport::Concern

  def edit_agents
    if params[:q].present?
      @searched_agents = Agent.search_for(params[:q])
      @searched_agencies = Agency.where('title like ?', "%#{params[:q]}%")
    end

    @statementable = fetch_statementable

    if params[:action_targets].present?
      params[:action_targets].each do |x_id|
        type, id = x_id.split(':')
        if type == 'agent'
          agent = Agent.find(id)
          @statementable.dedicated_agents << agent unless @statementable.dedicated_agents.include?(agent)
        elsif type == 'agency'
          agency = Agency.find(id)
          @statementable.action_targets.create(action_assignable: agency) unless @statementable.action_targets.exists?(action_assignable: agency)
        end
        @statementable.save
      end
    end

    render 'statementables/edit_agents'
  end

  def add_agent
    @agent = Agent.find_by(id: params[:agent_id])
    render_404 and return if @agent.blank?

    @statementable = fetch_statementable
    @statementable.dedicated_agents << @agent unless @statementable.dedicated_agents.include?(@agent)
    @statementable.save
    redirect_to polymorphic_path([:edit_agents, @statementable], q: params[:q])
  end

  def add_action_target
    action_assignable_model = params[:action_assignable_type].classify.safe_constantize
    @action_assignable = action_assignable_model.find_by(id: params[:action_assignable_id])
    render_404 and return if @action_assignable.blank?

    @statementable = fetch_statementable
    @statementable.action_targets.create(action_assignable: @action_assignable) unless @statementable.action_targets.exists?(action_assignable: @action_assignable)
    redirect_to polymorphic_path([:edit_agents, @statementable], q: params[:q])
  end

  def new_comment_agent
    @statementable = fetch_statementable
    @comment = Comment.new
    if @statementable.respond_to? :message_to_agent
      @comment.body = @statementable.message_to_agent + "<p></p>"
    end

    if params[:agent_id].present?
      @agent = Agent.find_by(id: params[:agent_id])
      render_404 and return if @agent.blank?

      render 'statementables/new_comment_agent'
    else
      render 'statementables/new_comment_agent_for_all'
    end
  end

  def edit_statements
    @statementable = fetch_statementable
    if params[:statement_q].present?
      @searched_agents = @statementable.agents.search_for(params[:statement_q])
    else
      @searched_agents = @statementable.agents
    end

    if params[:agent_id].present?
      @target_agent = Agent.find_by(id: params[:agent_id])
      @target_agent = nil unless @statementable.assigned?(@target_agent)
    end
    render 'statementables/edit_statements'
  end

  def update_statement_agent
    @statementable = fetch_statementable

    @statement = Statement.find_by(id: params[:statement_id])
    render_404 and return if @statement.blank?
    @statement_key = StatementKey.find_by(statement: @statement, key: params[:key])
    render_404 and return if @statement_key.blank?

    @agent = @statement.agent
    redirect_to polymorphic_path([:edit_statements, @statementable], agent_id: @agent.id, stance: params[:stance]) and return if @statement_key.expired?

    if params[:stance].present?
      @statement.stance = params[:stance]
      @statement.save
    end

    render 'statementables/update_statement_agent'
  end

  def remove_agent
    @agent = Agent.find_by(id: params[:agent_id])
    render_404 and return if @agent.blank?

    @statementable = fetch_statementable
    @statementable.dedicated_agents.delete(@agent) if @statementable.dedicated_agents.include?(@agent)
    redirect_to polymorphic_path([:edit_agents, @statementable], q: params[:q])
  end

  def remove_action_target
    action_assignable_model = params[:action_assignable_type].classify.safe_constantize
    @action_assignable = action_assignable_model.find_by(id: params[:action_assignable_id])
    render_404 and return if @action_assignable.blank?

    @statementable = fetch_statementable
    @statementable.action_targets.where(action_assignable: @action_assignable).destroy_all
    redirect_to polymorphic_path([:edit_agents, @statementable], q: params[:q])
  end

  def update_message_to_agent
    @statementable = fetch_statementable
    if @statementable.update_attributes(title_to_agent: params[:title_to_agent], message_to_agent: params[:message_to_agent])
      redirect_to @statementable
    else
      error_to_flash(@statementable)
      render 'statementables/edit_message_to_agent'
    end
  end

  def edit_message_to_agent
    @statementable = fetch_statementable
    render 'statementables/edit_message_to_agent'
  end

  private

  def init_statementable
    statementable = fetch_statementable
    statementable.title_to_agent = statementable.title
    statementable.message_to_agent = statementable.body
  end
end
