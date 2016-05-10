module MercadoPagoBlack
  class PaymentMethod < ActiveREST::Base

    has_crud_rest_methods(list: '/v1/payment_methods')

  end
end