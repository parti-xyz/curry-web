class EmailSubscriptionController < ApplicationController
  def unsubscribe
    id = Rails.application.message_verifier(:unsubscribe).verify(params[:id])

    @email_subscription = EmailSubscription.find(id)
    @title = params[:title]
    @link = params[:link]
  end

  def update
    @email_subscription = EmailSubscription.find(params[:id])

    if @email_subscription.update_attributes(use: params[:use])
      flash[:notice] = '이메일 수신거부하였습니다.'
      redirect_to root_url
    else
      flash.now[:alert] = '이메일 수신거부하지 못하였습니다.'
      render :unsubscribe
    end
  end
end
