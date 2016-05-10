module MercadoPagoBlack
  class IdentificationType < ActiveREST::Base

    has_crud_rest_methods(list: '/v1/identification_types')

  end
end