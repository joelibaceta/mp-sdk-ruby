class Cart < ActiveRecord::Base


  has_many :items
  belongs_to :user
  belongs_to :sale

  def self.get_current_cart(user)
    current_cart = Cart.where("state = 'created' AND user_id = ?", user.id).last
    current_cart ||= Cart.create({state: "created", user_id: user.id})
    return current_cart
  end

  def total
    self.items.map{|i| i.product.price * i.quantity}.reduce(:+)
  end

end
