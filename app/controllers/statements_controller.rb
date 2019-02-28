class StatementsController < ApplicationController
  load_and_authorize_resource only: :create
  def create
    @previous_statement = @statement.statementable.find_by(agent_id: @statement.agent_id)
    if @previous_statement.present?
      @previous_statement.assign_attributes(update_params)
      @statement = @previous_statement
    end

    @statement.last_updated_user = current_user
    if @statement.save
      flash[:notice] = I18n.t('messages.saved')
    else
      errors_to_flash(@statement)
    end

    redirect_to params[:after_save_url] || @statement.statementable
  end

  def update
    @statement = Statement.find_by(id: params[:id])
    render_404 and return if @statement.blank?
    if cannot?(:update, @statement)
      edit_path = polymorphic_path([:edit_statements, @statement.statementable], agent_id: @statement.agent.id)
      if params[:key].present? and !@statement.valid_key?(params[:key])
        flash[:error] = '입력을 시작한 지 너무 오래 되었습니다. 다시 시도해 주세요.'
        redirect_to edit_path and return
      end
      if @statement.agent.access_token != params[:access_token]
        flash[:error] = '비밀번호가 맞지 않습니다. 다시 시도해 주세요.'
        redirect_to edit_path and return
      end
    end

    @statement.assign_attributes(update_params)
    @statement.last_updated_user = current_user
    if @statement.save
      flash[:notice] = I18n.t('messages.saved')
    else
      errors_to_flash(@statement)
    end
    redirect_to params[:after_save_url] || @statement.statementable
  end

  private

  def create_params
    params.require(:statement).permit(:body, :stance, :agent_id, :statementable_type, :statementable_id)
  end

  def update_params
    params.require(:statement).permit(:body, :stance, :statementable_type, :statementable_id)
  end
end
