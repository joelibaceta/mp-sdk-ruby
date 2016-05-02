class Gateway::CardsController < ApplicationController
  before_action :authenticate_user!

  def index
    render :index, layout: "application_without_sidebar.haml"
  end

  def payment_form
    @card = Card.new
    @cards = Card.where(payment_provider: params[:payment_provider])
    @payment_provider = params[:payment_provider]
    render 'payment_form', layout: "application_without_sidebar.haml"
  end

  def create
    @card = Card.create({card_token: params[:token],
                         user_id: current_user.id,
                         provider_prefix: params[:paymentMethodId],
                         payment_provider: params[:provider],
                         last4: params[:last4],
                         first6: params[:first6]})
    redirect_to "/gateway/cards/payment_form?payment_provider=#{params[:provider]}"
  end
end