class Voteaward::UsersController < ApplicationController
  def index
    @v_users = Voteaward::User.all.limit(20)
  end

  def show
    @v_user = Voteaward::User.find(params[:id])
  end

  def send_confirm_email
    @v_user = Voteaward::User.find(params[:id])
    if @v_user
      unless @v_user.email_confirmed
        @v_user.confirmation_token
        VoteawardMailer.email_confirmation(@v_user).deliver
        flash[:success] = "Please confirm your email address to continue"
      end
    else
      flash[:error] = "User is not found"
    end
    redirect_to root_url
  end

  def confirm_email
    v_user = Voteaward::User.find_by_confirm_token(params[:id])

    if v_user
      v_user.email_activate
      flash[:success] = "Welcome to the Voteaward! Your email has been confirmed. Please sign in to continue."
      redirect_to new_user_session_url
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
  end

private
  def user_params
    params.require(:user).permit(:id)
  end

end
