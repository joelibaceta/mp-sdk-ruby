module MercadoPago
  class Payment < ActiveREST::Base

    #   Algorithms avaiblables
    #   SHA256, SHA384, SHA512, HMAC, SHA1, RMD160, MD5
    #
    set_idempotency_algorithm 'SHA256'

    has_rest_method create: '/v1/payments/', idempotency: true

    # ...
    has_strong_attribute :site_id,            idempotency_parameter: true
    has_strong_attribute :order_id,           idempotency_parameter: true
    has_strong_attribute :total_paid_amount,  idempotency_parameter: true
    # ...

    end
end
