module MercadoPago
  class Item < ActiveREST::Base
    not_allow_dynamic_attributes

    relation_belongs_to    :preference

    # Setting the strong attributes
    has_strong_attribute :id,           type: String,                 primary_key: true
    has_strong_attribute :title,        type: String
    has_strong_attribute :description,  type: String
    has_strong_attribute :category_id,  type: String
    has_strong_attribute :picture_url,  type: String
    has_strong_attribute :currency_id,  type: String
    has_strong_attribute :quantity,     type: Integer
    has_strong_attribute :unit_price,   type: Float

  end
end
