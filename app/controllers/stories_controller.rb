class StoriesController < ApplicationController
  include OrganizationHelper

  load_and_authorize_resource
  before_action :reset_meta_tags, only: :show
  before_action :verify_organization


  def index
    @stories = Story.recent

    @project = Project.find_by(slug: params[:project_id]) if params[:project_id]
    @stories = @stories.where(storiable: @project) if @project.present?

    @current_organization = fetch_organization_from_request
    @stories = @stories.by_organization(@current_organization) if @current_organization.present?
  end

  def show
    @project = @story.storiable if @story.storiable.is_a? Project
    @campaign = @story.storiable if @story.storiable.is_a? Campaign
    @story.increment!(:views_count)
  end

  def new
    storiable_model = params[:story][:storiable_type].classify.safe_constantize
    render_404 and return if storiable_model.blank?

    @storiable = storiable_model.find(params[:story][:storiable_id]) if params[:story][:storiable_id]
    authorize!(:create_story, @storiable) if @storiable.present?
    @current_organization = @storiable.organization if @storiable.present? and @storiable.is_a? Project
  end

  def create
    authorize!(:create_story, @story.storiable) if @story.storiable.present?
    @story.user = current_user
    if @story.save
      StoriesMailingJob.perform_async(@story.id)
      redirect_to @story
    else
      errors_to_flash @story
      send('new')
      render 'new'
    end
  end

  def edit
    @storiable = @story.storiable
  end

  def update
    if @story.update(story_params)
      redirect_to @story
    else
      errors_to_flash @story
      render 'edit'
    end
  end

  def destroy
    @story.destroy
    redirect_to polymorphic_url(@story.storiable)
  end

  private

  def story_params
    params.require(:story).permit(:title, :body, :storiable_id, :storiable_type, :cover, :comment_enabled, :published_at)
  end

  def reset_meta_tags
    prepare_meta_tags({
      site_name: ("#{@story.storiable.title}" if @story.storiable.present?),
      title: "[최신소식] " + @story.title,
      description: @story.body.html_safe,
      image: (view_context.image_url(@story.fallback_social_image_url) if @story.fallback_social_image_url),
      url: request.original_url}
    )
  end

  def current_organization
    if @story.present? and @story.persisted?
      @story.storiable.try(:organization)
    else
      fetch_organization_from_request
    end
  end
end
