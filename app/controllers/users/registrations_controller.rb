class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: [:create]
  prepend_before_action :check_captcha, only: [:create]

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

  def check_captcha
    resource = resource_class.new sign_up_params
    resource = resource_class.new_with_session(sign_up_params, session)
    return if !can_recaptcha? || verify_recaptcha(model: resource)

    self.resource = resource
    self.resource.validate
    set_minimum_password_length
    respond_with_navigational(self.resource) { render :new }
  end
end
