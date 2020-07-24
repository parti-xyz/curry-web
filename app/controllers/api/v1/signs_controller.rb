class Api::V1::SignsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    sign = Sign.new(sign_params)

    api_secure_key = request.headers[:HTTP_X_API_KEY]
    if sign.campaign.api_secure_key != api_secure_key
      head :unauthorized
      return
    end

    if params[:sign][:confirm_third_party]
      sign.confirm_third_party = Time.now
    end

    if sign.save
      render json: sign
    else
      # 캠페인이 닫긴 경우
      if sign.errors.added? :campaign, :closed, message: I18n.t('messages.campaigns.closed')
        render_json_error(:bad_request, :campaign_closed, sign)
      # 서명 이메일 중복
      elsif sign.errors.added? :signer_email, :taken
        render_json_error(:bad_request, :signer_email_taken, sign)
      # 이외 오류
      else
        render_json_error(:internal_server_error, :unknown, sign)
      end
    end
  end

  private

  def render_json_error(status, error_code, model = nil)
    status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol

    error = {
      code: error_code,
      status: status,
    }

    if Rails.env.development? and model.present?
      error[:debug] = model.errors.inspect
    end

    render json: { errors: [error] }, status: status
  end

  def sign_params
    params.require(:sign).permit(:body, :campaign_id,
      :signer_name, :signer_email, :signer_country, :signer_city, :signer_address, :signer_real_name, :signer_phone,
      :confirm_privacy)
  end
end