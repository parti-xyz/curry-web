class SimpleMailController < ApplicationController
  skip_before_action :verify_authenticity_token # so AWS callbacks are accepted

  def callback
    json = JSON.parse(request.raw_post)
    logger.info "notification callback from AWS with #{json}"
    aws_needs_url_confirmed = json['SubscribeURL']
    if aws_needs_url_confirmed
      logger.info "AWS is requesting confirmation of the notification handler URL"
      uri = URI.parse(aws_needs_url_confirmed)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.get(uri.request_uri)
    else
      logger.info "AWS has sent us the notification(s)"

      mail = json['mail']
      return if mail.blank?

      order_ids = []
      begin
        order_ids_json = mail['headers'].select { |header| header["name"] == 'X-PARTI-ORDERS' }.try(:first)
        order_ids = JSON.parse(order_ids_json["value"]) if order_ids_json.present?
      rescue
      end
      return if order_ids.blank?

      mailing_result_type = json['notificationType']
      mailing_result_subtype = case mailing_result_type
        when 'Bounce'
          "#{json['bounce']['bounceType']}::#{json['bounce']['bounceSubType']}"
        when 'Complaint'
          json['complaint']['complaintFeedbackType']
        else
        end

      recipients = case mailing_result_type
        when 'Bounce'
          json['bounce']['bouncedRecipients']
        when 'Complaint'
          json['complaint']['complainedRecipients']
        else
        end
      if recipients.present? and recipients.any?
        mailing_result_recipient = recipients.to_json
      end

      mailing_result_timestamp = case mailing_result_type
        when 'Bounce'
          json['bounce']['timestamp']
        when 'Complaint'
          json['complaint']['timestamp']
        else
        end

      Order.where(id: order_ids).update_all(mailing_result_type: mailing_result_type, mailing_result_subtype: mailing_result_subtype, mailing_result_recipient: mailing_result_recipient, mailing_result_timestamp: mailing_result_timestamp)
    end
  end
end