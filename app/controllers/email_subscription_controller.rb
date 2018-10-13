class EmailSubscriptionController < ApplicationController
  def unsubscribe
    email = Rails.application.message_verifier(:unsubscribe).verify(params[:id])
    @subscription = EmailSubscription.find_by(email: email)
    @title = params[:title]
    @link = params[:link]
  end

  def update
    @subscription = EmailSubscription.find(params[:id])
    if @subscription.update(email_params)
      flash[:notice] = '이메일 수신거부하였습니다.'
      redirect_to root_url
    else
      flash[:alert] = '이메일 수신거부하지 못하였습니다.'
      render :unsubscribe
    end
  end

private
  def email_params
    params.require(:email_subscription).permit(:use)
  end
end
