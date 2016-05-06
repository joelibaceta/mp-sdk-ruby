module MercadoPagoBlack
  class PaymentMethod
    include MercadopagoObject

    act_as_api_resource(list_url: '/v1/payment_methods')

  end
end