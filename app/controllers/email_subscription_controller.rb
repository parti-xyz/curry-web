class EmailSubscriptionController < ApplicationController
  def unsubscribe
    sign_id = Rails.application.message_verifier(:unsubscribe).verify(params[:id])
    @sign = Sign.find(sign_id)
    @title = params[:title]
    @link = params[:link]
  end

  def update
    @sign = Sign.find(params[:id])

    if @sign.update(subscription_params)
      flash[:notice] = '이메일 수신거부하였습니다.'
      redirect_to root_url
    else
      flash[:alert] = '이메일 수신거부하지 못하였습니다.'
      render :unsubscribe
    end
  end

private
  def subscription_params
    params.require(:sign).permit(:subscribed)
  end
end
