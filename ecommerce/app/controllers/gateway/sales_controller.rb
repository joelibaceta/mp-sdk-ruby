class Gateway::SalesController < ApplicationController
  before_action :authenticate_user!

  def new
    #TODO: List payment ways

    render :new, layout: "application_without_sidebar.haml"
  end

  def payment_form
    @sale = Sale.new
    @sale.cart = Cart.get_current_cart(current_user)
    @payment_provider = params[:payment_provider]
    @cards = Card.where(payment_provider: params[:payment_provider])

    render 'payment_form'
  end

  def create

  end
end
