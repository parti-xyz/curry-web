class Api::V1::SignsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    sign = Sign.new(sign_params)

    api_secure_key = request.headers[:HTTP_X_API_KEY]
    if sign.campaign.api_secure_key != api_secure_key
      render_json_error(:unauthorized, :invalid_secure_key, sign)
      return
    end

    if params[:sign][:confirm_third_party]
      sign.confirm_third_party = Time.now
    end

    if sign.save
      render json: {
        sign: sign,
        signs_count: sign.campaign.signs_count
      }
    else
      # 캠페인이 닫긴 경우
      if has_error?(sign, :campaign, :closed)
        render_json_error(:bad_request, :campaign_closed, sign)
      # 서명 이메일 중복
      elsif has_error?(sign, :signer_email, :taken)
        render_json_error(:bad_request, :signer_email_taken, sign)
      # 서명 이메일 포맷 에러
      elsif has_error?(sign, :signer_email, :invalid)
        render_json_error(:bad_request, :signer_email_invalid, sign)
      # 이외 오류
      else
        Rails.logger.error("Error: ")
        Rails.logger.error(sign.errors.inspect)
        render_json_error(:internal_server_error, :unknown, sign)
      end
    end
  end

  private

  def has_error?(sign, attribute, type)
    details = sign.errors.details[attribute]
    return false if details.blank?

    details.any?{ |detail| detail[:error] == type }
  end

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
