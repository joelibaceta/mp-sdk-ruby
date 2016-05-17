module MercadoPago
  class PaymentMethod < ActiveREST::Base

    has_rest_method list: '/v1/payment_methods'

  end
end