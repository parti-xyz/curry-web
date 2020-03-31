class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token, :only => :create

  # Overwrite update_resource to let users to update their user without giving their password
  def update_resource(resource, params)
    # abort params.inspect
    resource.update_without_password(params)
  end

  private

  def sign_up_params
    params.require(:user).permit(:remember_me, :nickname, :image, :email, :password, :password_confirmation, :term_service, :term_privacy, :term_marketing, :term_privacy_must)
  end

  def account_update_params
    params.require(:user).permit(:remember_me, :nickname, :description, :image, :email, :enable_mailing, :site_info, :facebook_info, :twitter_info, :term_privacy_must, :term_marketing)
  end

  def after_inactive_sign_up_path_for(resource)
    root_path
  end
end
