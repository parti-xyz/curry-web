class UsersController < ApplicationController
  def index
    @users = User.order('id DESC')
  end

  def show
    @user = User.find(params[:id])
    prepare_meta_tags({
      site_name: "[빠띠 캠페인즈] - #{@user.nickname}",
      title: @user.nickname,
      description: @user&.description&.html_safe,
      image: view_context.image_url(@user.image),
      url: request.original_url,
    })
  end

  def update
    if current_user.update(user_terms_params)
      redirect_to root_path
    else
      render "users/confirm_terms"
    end
  end

  def confirm_terms
    redirect_to root_path unless user_signed_in?
  end

  private
  def user_terms_params
    params.require(:user).permit(:term_service, :term_privacy, :term_marketing, :term_privacy_must)
  end
end
