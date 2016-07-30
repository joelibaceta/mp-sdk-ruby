module MercadoPago
  class Shipment < ActiveREST::Base

    has_strong_attribute :id,                        primary_key: true
    has_strong_attribute :mode,                      type: String,    valid_values: ["custom", "me2", "not_specified"]
    has_strong_attribute :local_pickup,              valid_values: [true, false]
    has_strong_attribute :dimensions,                type: String
    has_strong_attribute :default_shipping_method,   type: Integer
    
    # Free Shipping
    #
    #  OCA Estándar    : 73328
    #  OCA Prioritario : 73330
    #
    has_strong_attribute :free_methods,              type: Array
    
    has_strong_attribute :cost,                      type: Float
    has_strong_attribute :free_shipping
    has_strong_attribute :receiver_address,          type: Hash
    

    before_api_request { set_param :access_token, MercadoPago::Settings.ACCESS_TOKEN }

  end
end