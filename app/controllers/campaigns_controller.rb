class CampaignsController < ApplicationController
  protect_from_forgery except: :widget_v1_sdk

  include OrganizationHelper
  include Statementing

  load_and_authorize_resource
  before_action :reset_meta_tags_for_show
  before_action :verify_organization

  def index
    @campaigns = Campaign.published.recent
    @current_organization = fetch_organization_from_request
    @campaigns = @campaigns.search_for(params[:q]) if params[:q].present?
    @campaigns = @campaigns.by_organization(@current_organization) if @current_organization.present?
    @campaigns = @campaigns.page(params[:page]).per(21)
  end

  def show
    respond_to do |format|
      format.html do
        @project = @campaign.project
        @signs = @campaign.signs.recent
        @signs = @signs.signs_featured(current_user)

        @signs = params[:mode] == 'widget' ? @signs.limit(10) : @signs.page(params[:page])

        @campaign.increment!(:views_count)

        if @campaign.template != 'petition'
          @comments = params[:tag].present? ? @campaign.comments.tagged_with(params[:tag]) : @campaign.comments
          @comments = params[:toxic].present? ? @comments.where(toxic: true) : @comments.where(toxic: false)
          @comments = @comments.order('id DESC')
          @comments = @comments.page(params[:page]).per 50
        end

        if @campaign.template == 'special_speech'
          @speeches = @campaign.speeches.recent.limit(browser.device.mobile? ? 4 : 8)
          @hero_speech = @campaign.speeches.sample
        elsif %w(basic photo map).include? @campaign.template
          redirect_to pickets_campaign_path(@campaign)
        end

        if params[:mode] == 'widget'
          render '_widget', layout: 'strip'
        end
      end
      format.json
    end
  end

  def data
  end

  def new
    if params[:template].blank? or not @campaign.is_valid_template(params[:template])
      return render 'new_no_template'
    end

    @project = Project.find(params[:project_id]) if params[:project_id].present?
    @current_organization = @project.organization if @project.present?
    @campaign.template = params[:template]
  end

  def create
    @campaign.user = current_user
    if @campaign.special_slug.present?
      Special.build_campaign @campaign
    end

    if params[:action_assignable_id].present? and params[:action_assignable_type].present?
      action_assignable_model = params[:action_assignable_type].classify.safe_constantize
      render_404 and return if action_assignable_model.blank?
      action_assignable = action_assignable_model.find_by(id: params[:action_assignable_id])
      render_404 and return if action_assignable.blank?

      @campaign.action_targets.build(action_assignable: action_assignable)
    end

    if @campaign.save
      @campaign.issue&.followers&.each{ |x| FollowingIssueMailer.notify(x, @campaign.issue, @campaign).deliver_later }
      redirect_to @campaign
    else
      render 'new'
    end
  end

  def edit
    @project = @campaign.project
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to @campaign
    else
      render 'edit'
    end
  end

  def destroy
    @campaign.destroy
    redirect_to @campaign.project ? project_path(@campaign.project) : campaigns_path
  end

  def open
    @campaign.update_attributes(closed_at: nil)
    flash[:success] = t('messages.campaigns.open')
    redirect_to @campaign
  end

  def close
    @campaign.touch(:closed_at)
    flash[:success] = t('messages.campaigns.close')
    redirect_to @campaign
  end

  def sign_form
    if @campaign.template == 'petition' and request.format.js?
      render 'campaigns/petition/sign_form'
    else
      render_404
    end
  end

  def order_form
    @comment = Comment.new
    @comment.is_html_body = true
    @comment.body = (@campaign.message_to_agent || '') + "<p></p>"
  end

  def picket_form
    if %(basic photo map).include?(@campaign.template) and request.format.js?
      render 'campaigns/picket/picket_form'
    else
      render_404
    end
  end

  def orders
    if %(basic photo map).include?(@campaign.template)
      render template: "campaigns/picket/orders"
    else
      render template: "campaigns/#{@campaign.template}/orders"
    end
  end

  def need_to_order_agents
    @agents = @campaign.need_to_order_agents.order(name: :asc).page(params[:page]).per(10)
    render template: "campaigns/need_to_order_agents"
  end

  def agents
    @agents = @campaign.agents.order(name: :asc).page(params[:page]).per(10)
    render template: "campaigns/agents"
  end

  def comments
    render_404 and return unless %(petition order order_assembly photo map).include?(@campaign.template)
    render template: "campaigns/#{@campaign.template}/comments"
  end

  def comments_data
    respond_to do |format|
      format.xlsx
    end
  end

  def orders_data
    respond_to do |format|
      format.xlsx
    end
  end

  def stories
    render_404 and return unless %(petition order order_assembly basic photo map).include?(@campaign.template)
    if %(basic photo map).include?(@campaign.template)
      render template: "campaigns/picket/stories"
    else
      render template: "campaigns/#{@campaign.template}/stories"
    end
  end

  def signers
    @signs = @campaign.signs.order('id desc').page(params[:page])
    render template: "campaigns/#{@campaign.template}/signers"
  end

  def story
    @story = Story.find params[:story_id]
    @story.increment!(:views_count)
    render 'campaigns/story'
  end

  def contents
    render_404 and return unless %(basic photo map).include?(@campaign.template)
    render template: "campaigns/picket/contents"
  end

  def pickets
    render_404 and return unless %(basic photo map).include?(@campaign.template)
    if params[:tag].present?
      @pickets = @campaign.comments.tagged_with(params[:tag]).recent.page(params[:page]).per(9)
    elsif params[:map_bounds].present?
      @pickets = @campaigns.comments.select{ |c| c.latitude.present? }
    elsif params[:pickets_user_id].present?
      @pickets = @campaign.comments.where(user_id: params[:pickets_user_id]).recent.page(params[:page]).per(9)
    else
      @pickets = @campaign.comments.recent.page(params[:page]).per(9)
    end
    render template: "campaigns/picket/pickets"
  end

  def picket
    render_404 and return unless %(basic photo map).include?(@campaign.template)

    @picket = Comment.find_by(id: params[:picket_id])
    render_404 and return if @picket.blank?
    render template: "campaigns/picket/picket"
  end

  def widget_v1_sdk
    @campaign = Campaign.find(params[:campaign_id])
    render template: "campaigns/widget/v1/sdk", layout: nil
  end

  def widget_v1_content
    @campaign = Campaign.find(params[:campaign_id])
    render template: "campaigns/widget/v1/content", layout: 'widget'
  end

  def stealthily
    @campaign.update_attributes(stealthily: params[:value])
    flash[:success] = t('messages.saved')
    redirect_to @campaign
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :body, :project_id, :goal_count, :cover_image, :thanks_mention,
      :comment_enabled, :sign_title, :sign_placeholder, :social_image, :confirm_third_party, :opened_at, :stealthily,
      :use_signer_email, :use_signer_address, :use_signer_real_name, :use_signer_phone, :use_signer_country, :use_signer_city,
      :signer_email_title, :signer_address_title, :signer_real_name_title,
      :signer_country_title,  :signer_city_title, :signer_phone_title,
      :agent_section_title, :agent_section_response_title, :sign_hidden, :area_id, :issue_id,
      :special_slug, :sign_form_intro, (:template if params[:action] == 'create'), :slug, :title_to_agent, :message_to_agent,
      :agent_id, :css, :need_stance, :ga_id)
  end

  def reset_meta_tags_for_show
    return if @campaign.blank? or !@campaign.persisted?
    prepare_meta_tags({
      site_name: ("#{@campaign.project.title} - #{@campaign.project.user.nickname}" if @campaign.project.present?),
      title: "[캠페인] " + @campaign.title,
      description: @campaign.body.html_safe,
      image: (view_context.image_url(@campaign.fallback_social_image_url) if @campaign.fallback_social_image_url),
      url: request.original_url}
    )
  end

  def current_organization
    if @campaign.present? and @campaign.persisted?
      @campaign.project.try(:organization)
    else
      fetch_organization_from_request
    end
  end

  # for Statementing
  def fetch_statementable
    @campaign
  end
end
