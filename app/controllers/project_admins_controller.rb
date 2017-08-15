class ProjectAdminsController < ApplicationController
  load_and_authorize_resource

  def index
    @project = Project.find_by id: params[:project_id]
    render_404 and return if @project.blank?
  end

  def create
    user_nickname = params[:user_nickname]
    user = User.find_by(nickname: user_nickname)
    redirect_back(fallback_location: root_path) and return if user.blank? or
      @project_admin.project.blank? or
      @project_admin.project.project_admins.exists?(user: user)

    @project_admin.user = user
    @project_admin.save!

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @project_admin.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def project_admin_params
    params.require(:project_admin).permit(:project_id)
  end
end