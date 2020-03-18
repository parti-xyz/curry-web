class PagesController < ApplicationController
  include OrganizationHelper

  before_action :subdomain_view_path, only: :home

  def about
  end

  def terms
    render "pages/terms"
  end

  def privacy
    render "pages/terms"
  end

  def privacy_must
    render "pages/terms"
  end

  def privacy_option
    render "pages/terms"
  end

  def privacy_third
    render "pages/terms"
  end

  def marketing
    render "pages/terms"
  end

  def polls
    @polls = Poll.recent
  end

  def campaigns
    @campaigns = Campaign.recent
  end

  def discussions
    @discussions = Discussion.recent
  end

  private

  def subdomain_view_path
    return unless organizationable_request?(request)
    @current_organization ||= fetch_organization_from_request
    if @current_organization.blank?
      redirect_to "http://#{Rails.application.routes.default_url_options[:host]}"
      return
    end
    prepend_view_path "app/views/organizations/#{@current_organization.slug}"
  end

  def reset_meta_tags_for_home(organization)
    prepare_meta_tags({
      site_name: organization.try(:site_name).try(:html_safe),
      title: organization.try(:title).try(:html_safe),
      description: organization.try(:description).try(:html_safe),
      url: request.original_url}
    )
  end
end
