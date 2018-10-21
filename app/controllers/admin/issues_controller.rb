class Admin::IssuesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @issues = Issue.all
    @issues = Agenda.find_by(id: params[:agenda_id]).issues if params[:agenda_id].present?
    @issues = @issues.search_for(params[:q]) if params[:q].present?
  end

  def create
    if @issue.save
      redirect_to admin_issues_path
    else
      errors_to_flash(@issue)
      render 'new'
    end
  end

  def update
    if @issue.update(issue_params)
      redirect_to admin_issues_path
    else
      render 'edit'
    end
  end

  def destroy
    @issue.destroy
    redirect_to admin_issues_path
  end

  def edit_campaigns
  end

  def search_campaigns
    @campaigns = Campaign.search_for(params[:q])
    @campaigns = @campaigns.page(params[:page]).per(30) if params[:page]
  end

  def add_campaign
    @campaign = Campaign.find_by(id: params[:campaign_id])
    render_404 and return if @campaign.blank?
    @campaign.update_attributes(issue: @issue)

    redirect_to [:edit_campaigns, :admin, @issue]
  end

  def remove_campaign
    @campaign = Campaign.find_by(id: params[:campaign_id])
    render_404 and return if @campaign.blank?
    @campaign.update_attributes(issue: nil)

    redirect_to [:edit_campaigns, :admin, @issue]
  end

  private

  def issue_params
    params.require(:issue).permit(:agenda_theme_id, :title, :body, :tag_list, :has_stance, :image, agenda_ids: [])
  end
end
