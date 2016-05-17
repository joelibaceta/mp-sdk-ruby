module MercadoPago
  class IdentificationType < ActiveREST::Base

    has_rest_method list: '/v1/identification_types'


  end
end