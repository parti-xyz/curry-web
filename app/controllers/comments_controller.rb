class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:create, :index, :show, :readers, :new]
  load_and_authorize_resource

  def index
    if params[:commentable_type].nil?
      redirect_to root_url and return
    end

    @commentable_model = params[:commentable_type].classify.safe_constantize
    render_404 and return if @commentable_model.blank?
    @commentable = @commentable_model.find(params[:commentable_id])
    if params[:only_my_comments].present?
      @comments = @commentable.comments.where(user: current_user&.id).recent.page(params[:page])
    else
      @comments = @commentable.comments.page(params[:page])

      if params[:sort] == 'merged_likes_count'
        @comments = @comments.order(merged_likes_count: :desc)
      else
        @comments = @comments.recent
      end
    end
    @comments = @comments.with_target_agent(Agent.find_by(id: params[:target_agent_id])) if params[:target_agent_id].present?

    if params[:partial].present?
      render layout: nil
    end
  end

  def create
    if can_recaptcha? and !verify_recaptcha(model: @comment)
      errors_to_flash(@comment)
      redirect_back(fallback_location: root_path)
      return
    end

    if @comment.commentable.try(:comment_closed?)
      flash[:notice] = t("messages.#{@comment.commentable_type.pluralize.underscore}.closed")
      redirect_back(fallback_location: root_path, i_am: params[:i_am]) and return
    end

    @comment.user = current_user if user_signed_in?
    if user_signed_in? and @comment.commentable.respond_to? :voted_by? and @comment.commentable.voted_by? current_user
      @comment.choice = @comment.commentable.fetch_vote_of(current_user).choice
    end

    @comment.mailing ||= :disable
    if @comment.mailing.ready? and @comment.user_id.blank? and @comment.commenter_email.blank?
      flash[:error] = I18n.t('messages.need_to_email')
      redirect_back(fallback_location: root_path, i_am: params[:i_am])
      return
    end

    if @comment.mailing.ready? and @comment.commentable.try(:closed?)
      flash[:error] = I18n.t('messages.closed_commentable')
      redirect_back(fallback_location: root_path, i_am: params[:i_am])
    end

    if @comment.mailing.ready? and @comment.commentable.respond_to?(:agents)
      if @comment.target_agent_id.blank?
        target_agents = if params[:order_filter] == 'no_reaction'
          @comment.commentable.need_to_order_agents
        else
          @comment.commentable.agents
        end
        if params[:action_assignable_type].present? and params[:action_assignable_id].present?
          action_assignable_model = params[:action_assignable_type].classify.safe_constantize
          if action_assignable_model.present?
            action_assignable = action_assignable_model.find_by_id(params[:action_assignable_id])
            target_agents = @comment.commentable.need_to_order_agents(action_assignable)
          end
        end

        target_agents.each do |agent|
          @comment.target_agents << agent
        end
      else
        @comment.target_agents << Agent.find_by(id: @comment.target_agent_id)
      end
    end

    @comment.confirm_privacy = true if @comment.commentable.try(:confirm_privacy).present?

    unless @comment.is_html_body?
      @comment.body = ApplicationController.helpers.smart_format(@comment.body)
      @comment.is_html_body = true
    end

    if @comment.save
      flash[:notice] = if @comment.target_agents.any?
        I18n.t('messages.order_commented')
      else
        I18n.t('messages.commented')
      end

      if @comment.commentable.try(:statementable?)
        @comment.orders.each do |order|
          agent = order.agent
          statement = @comment.commentable.statements.find_or_create_by(agent: agent)
          statement_key = statement.statement_keys.build(key: SecureRandom.hex(50))
          statement_key.save!
          if @comment.mailing.ready? and agent.email.present?
            CommentToAgentJob.perform_async({ comment_id: @comment.id, order_id: order.id, statement_key_id: statement_key.id })
          end
        end
      end

      if @comment.mailing.ready?
        if @comment.target_agents.empty? { |agent| agent.email.present? }
          @comment.update_attributes(mailing: :fail)
        end
      end
    else
      errors_to_flash(@comment)
    end

    if params[:back_commentable].present?
      redirect_to @comment.commentable
    else
      redirect_back(fallback_location: root_path, i_am: params[:i_am])
    end
  end

  def update
    @comment.update(comment_params)
  end

  def destroy
    @comment.destroy
    redirect_to :back
  end

  def new
    if params[:commentable_type].nil?
      render_404 and return
    end

    @commentable_model = params[:commentable_type].classify.safe_constantize
    render_404 and return if @commentable_model.blank?
    @commentable = @commentable_model.find(params[:commentable_id])
  end

  def readers
    @comment = Comment.find_by(id: params[:id])
    render layout: nil
  end

  def show
    respond_to do |format|
      format.json {
        render json: {
            id: @comment.id,
            created_at: @comment.created_at,
            nickname: @comment.user_nickname,
            image: @comment.image.sm.url,
            latitude: @comment.latitude,
            longitude: @comment.longitude,
            body: @comment.body
          }.to_json
      }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(
      :body, :commentable_id, :commentable_type,
      :commenter_name, :commenter_email,
      :full_street_address,
      :tag_list, :image,
      :target_agent_id, :mailing,
      :toxic,
      :test, :comment_user_id, :is_html_body
    )
  end
end
