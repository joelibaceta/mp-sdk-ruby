class ItemsController < ApplicationController
  before_action :authenticate_user!

  def new
    cart = Cart.get_current_cart(current_user)
    product = Product.find(params[:product_id])
    @item = Item.new({product: product, cart: cart})
  end

  def create
    @item = Item.new(item_params)
    @item.save
    redirect_to products_path
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to products_path
  end

  private
  def item_params
    params.require(:item).permit(:quantity, :product_id, :cart_id)
  end
end
