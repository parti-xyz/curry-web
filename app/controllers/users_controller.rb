class UsersController < ApplicationController
  def index
    @users = User.order('id DESC')
  end

  def show
    @user = User.find(params[:id])
  end

  def confirm_terms
  end

  def update
    if current_user.update(user_terms_params)
      redirect_to after_sign_up_path(resource)
    else
      render "users/confirm_terms"
    end
  end

  private 
  def user_terms_params
    params.require(:user).permit(:term_service, :term_privacy, :term_marketing)
  end
end
