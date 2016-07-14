module MercadoPago
  class Refund < ActiveREST::Base
    
    has_rest_method create:   'v1/payments/:payment_id/refunds' 
    before_api_request { set_param :access_token, MercadoPago::Settings.ACCESS_TOKEN }
    
  end
end