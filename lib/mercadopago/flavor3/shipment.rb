module MercadoPago
  class Shipment < ActiveREST::Base

    has_strong_attribute :mode,                      type: String
    has_strong_attribute :local_pickup
    has_strong_attribute :dimensions,                type: String
    has_strong_attribute :default_shipping_method,   type: Integer
    has_strong_attribute :free_methods,              type: Array
    has_strong_attribute :cost,                      type: Float
    has_strong_attribute :free_shipping
    has_strong_attribute :receiver_address,          type: Hash

  end
end