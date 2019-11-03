class NotesController < ApplicationController
  before_action :authenticate_user!, except: :create
  load_and_authorize_resource

  def create
    if can_recaptcha? and verify_recaptcha(model: @note)
      errors_to_flash(@note)
      redirect_back(fallback_location: root_path)
      return
    end

    @note.user = current_user if user_signed_in?
    if user_signed_in? and @note.opinion.respond_to? :voted_by? and @note.opinion.voted_by? current_user
      @note.choice = @note.opinion.fetch_vote_of(current_user).choice
    end
    if @note.save
      if @note.sent_email? and @note.opinion.agent.email.present?
        AgendaMailer.note(@note.id).deliver_later
      end

      flash[:notice] = I18n.t('messages.saved')
    else
      errors_to_flash(@note)
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @note.destroy
    redirect_to :back
  end

  private

  def note_params
    params.require(:note).permit(
      :body, :opinion_id,
      :writer_name, :writer_email,
      :full_street_address,
      :tag_list, :image,
      :sent_email
    )
  end
end
