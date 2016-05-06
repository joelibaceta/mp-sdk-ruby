module MercadoPagoBlack
  class IdentificationType
    include MercadopagoObject

    act_as_api_resource(list_url: '/v1/identification_types')

  end
end