class Users::SessionsController < Devise::SessionsController
  protected
  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.banned?
      sign_out resource
      flash[:error] = "접속이 차단되었습니다. contact@campaigns.kr으로 연락부탁드립니다."
      root_path
    else
      super
    end
  end
end