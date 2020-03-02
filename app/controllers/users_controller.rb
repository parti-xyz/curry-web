class UsersController < ApplicationController
  def index
    @users = User.order('id DESC')
  end

  def show
    @user = User.find(params[:id])
    prepare_meta_tags({
      site_name: "[빠띠 캠페인즈] - #{@user.nickname}",
      title: @user.nickname,
      description: @user.description.html_safe,
      image: view_context.image_url(@user.image),
      url: request.original_url,
    })
  end
end
