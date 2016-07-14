module MercadoPago
  class IdentificationType < ActiveREST::Base

    has_rest_method list: '/v1/identification_types' 
    before_api_request { set_param :access_token, MercadoPago::Settings.ACCESS_TOKEN }

  end
end