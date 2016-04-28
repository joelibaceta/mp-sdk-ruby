class Sale < ActiveRecord::Base
  has_one :cart
end
