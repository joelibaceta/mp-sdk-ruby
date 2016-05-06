module MercadoPagoBlack
  class Preference
    include MercadopagoObject

    act_as_api_resource(create_url: '/checkout/preferences',
                        read_url:   '/checkout/preferences/:id',
                        update_url: '/checkout/preferences/:id')

  end
end