class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:create, :index, :show]
  load_and_authorize_resource

  def index
    if params[:commentable_type].nil?
      redirect_to root_url
    else
      @commentable_model = params[:commentable_type].classify.safe_constantize
      render_404 and return if @commentable_model.blank?
      @commentable = @commentable_model.find(params[:commentable_id])
      if params[:comment_user_id].present?
        @comments = @commentable.comments.where(user: User.find(params[:comment_user_id])).recent.page(params[:page])
      else
        @comments = @commentable.comments.recent.page(params[:page])
      end
      @comments = @comments.with_target_agent(Agent.find_by(id: params[:agent_id])) if params[:agent_id].present?
    end
  end

  def create
    unless verify_recaptcha(model: @comment)
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

    if @comment.mailing.ready? and @comment.commentable.respond_to?(:agents)
      if @comment.target_agent_id.blank?
        target_agents = @comment.commentable.not_agree_agents
        if params[:action_assignable_type].present? and params[:action_assignable_id].present?
          action_assignable_model = params[:action_assignable_type].classify.safe_constantize
          if action_assignable_model.present?
            action_assignable = action_assignable_model.find_by_id(params[:action_assignable_id])
            target_agents = @comment.commentable.not_agree_agents(action_assignable)
          end
        end

        target_agents.each do |agent|
          @comment.target_agents << agent
        end
      else
        @comment.target_agents << Agent.find_by(id: @comment.target_agent_id)
      end
    end

    if @comment.save
      flash[:notice] = I18n.t('messages.commented')

      if @comment.commentable.try(:statementable?)
        @comment.target_agents.each do |agent|
          statement = @comment.commentable.statements.find_or_create_by(agent: agent)
          statement_key = statement.statement_keys.build(key: SecureRandom.hex(50))
          statement_key.save!
          if @comment.mailing.ready? and agent.email.present?
            CommentMailer.target_agent(@comment.id, agent.id, statement_key.id).deliver_later
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

  private

  def comment_params
    params.require(:comment).permit(
      :body, :commentable_id, :commentable_type,
      :commenter_name, :commenter_email,
      :full_street_address,
      :tag_list, :image,
      :target_agent_id, :mailing,
      :toxic,
      :test, :comment_user_id
    )
  end
end
