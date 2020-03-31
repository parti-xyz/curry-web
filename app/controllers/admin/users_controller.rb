class Admin::UsersController < Admin::BaseController
  def download_emails
    emails_before = User.select { |u| u.email.present? }.map { |u| { nickname: u.nickname,
      email: u.email } }
    @emails = emails_before.uniq! {|e| e[:email] }

    respond_to do |format|
      format.xlsx
    end
  end

  def index
    @banned_users = User.where.not(banned_at: nil)
    if params[:user_nickname].present?
      @user = User.find_by(nickname: params[:user_nickname])
    end
  end

  def ban
    @user = User.find(params[:id])
    @user.touch(:banned_at)
    redirect_to admin_users_path(user_nickname: @user.nickname)
  end

  def unban
    @user = User.find(params[:id])
    @user.update_columns(banned_at: nil)
    redirect_to admin_users_path(user_nickname: @user.nickname)
  end
end

