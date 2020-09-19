class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  prepend_before_action :require_no_authentication, only: [:facebook, :twitter, :naver]

  def facebook
    run_omniauth
  end

  def twitter
    run_omniauth
  end

  def naver
    run_omniauth
  end

  def failure
    logger.fatal "Omniauth Fail : kind: #{OmniAuth::Utils.camelize(failed_strategy.try(:name))}, reason: #{failure_message}"
    logger.fatal "Omniauth Env : #{request.env.inspect}"
    redirect_to root_path
  end

  private

  def run_omniauth
    parsed_data = User.parse_omniauth(request.env["omniauth.auth"])
    remember_me = request.env["omniauth.params"].try(:fetch, "remember_me", false)
    parsed_data[:remember_me] = remember_me
    @user = User.find_for_omniauth(parsed_data)
    if @user.present?
      @user.remember_me = remember_me
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => @user.provider) if is_navigational_format?
    else
      session["devise.omniauth_data"] = parsed_data
      session["omniauth.params_data"] = request.env["omniauth.params"]
      redirect_to new_user_registration_url
    end
  end
end
