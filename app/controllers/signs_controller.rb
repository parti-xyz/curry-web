class SignsController < ApplicationController
  before_action :authenticate_user!, except: [:create, :index]
  load_and_authorize_resource except: [:mail_form, :mail]

  def index
    @campaign = Campaign.find params[:campaign_id]
    @signs = @campaign.signs.page params[:page]
  end

  def create
    if can_recaptcha? and !verify_recaptcha(model: @sign)
      errors_to_flash(@sign)
      redirect_back(fallback_location: root_path)
      return
    end

    if user_signed_in? and @sign.campaign.signed?(current_user)
      flash[:notice] = t('messages.already_signed')
      redirect_to(@sign.campaign) and return
    end

    if @sign.campaign.closed?
      flash[:notice] = t('messages.campaigns.closed')
      redirect_to(@sign.campaign) and return
    end

    @sign.user = current_user if user_signed_in?
    @sign.confirm_privacy = true if @sign.campaign.confirm_privacy.present?
    if @sign.save
      flash[:sign_notice] = view_context.fill_in(@sign.campaign.thanks_mention, number: @sign.campaign.signs_count) || I18n.t('messages.signed')
    else
      errors_to_flash(@sign)
    end
    redirect_back(fallback_location: @campaign)
  end

  def update
    if @sign.update_attributes(sign_params)
      flash[:success] = t('messages.saved')
    else
      errors_to_flash(@sign)
    end
    redirect_to(@sign.campaign)
  end

  def destroy
    errors_to_flash(@sign) unless @sign.destroy
    redirect_to(@sign.campaign)
  end

  def mail_form
    @campaign = Campaign.find_by(id: params[:campaign_id])
    render_404 and return if @campaign.blank?

    authorize! :mail_signs, @campaign
    if @campaign.signs.empty?
      flash[:error] = t('messages.signs.mail.empty_signer')
      redirect_back(fallback_location: @campaign)
    end
    @draft = SignerEmail.where(draft: true, user_id: current_user.id, campaign_id: @campaign.id).last || SignerEmail.new(title: "", body: "", user_id: current_user.id, campaign_id: @campaign.id)
  end

  def mail
    @campaign = Campaign.find_by(id: params[:campaign_id])
    render_404 and return if @campaign.blank?
    authorize! :mail_signs, @campaign

    if params[:title].blank?
      flash[:error] = t('messages.signs.mail.blank_title')
      redirect_back(fallback_location: @campaign)
      return
    end

    if params[:preview_email].blank? and params[:preview] == "true"
      flash[:error] = t('messages.signs.mail.blank_preview_email')
      redirect_back(fallback_location: @campaign)
      return
    end

    email = SignerEmail.where(user_id: current_user.id, campaign_id: @campaign.id, draft: true).last || SignerEmail.new(user_id: current_user.id, campaign_id: @campaign.id)
    email.title = params[:title]
    email.body = params[:body]
    if params[:commit] == "임시 저장"
      email.save
      flash[:success] = t('messages.signs.mail.save_draft')
      redirect_to mail_form_campaign_signs_path(@campaign)
      return
    else
      email.draft = false
      email.save
    end

    SignsMailingJob.perform_async(@campaign.id, params[:title], params[:body], (params[:preview_email] if params[:preview] == 'true'), current_user.id)
    if params[:preview] == 'true'
      flash[:success] = t('messages.signs.mail.preview_completed')
      render "signs/mail_form"
      return
    else
      flash[:success] = t('messages.signs.mail.completed')
    end
    redirect_to @campaign
  end

  private

  def sign_params
    params.require(:sign).permit(:body, :campaign_id,
      :signer_name, :signer_email, :signer_address, :signer_real_name, :signer_phone,
      :extra_29_confirm_join)
  end
end
