module MercadoPago
  class Card < ActiveREST::Base

    has_rest_method list:     '/v1/customers/:customer_id/cards'
    has_rest_method create:   '/v1/customers/:customer_id/cards'
    has_rest_method read:     '/v1/customers/:customer_id/cards/:id'
    has_rest_method update:   '/v1/customers/:customer_id/cards/:id'
    has_rest_method destroy:  '/v1/customers/:customer_id/cards/:id'

    has_relation  belongs_to: 'customer'

    has_strong_attribute :id
    has_strong_attribute :customer_id,        allow_null: false
    has_strong_attribute :expiration_month
    has_strong_attribute :expiration_year
    has_strong_attribute :first_six_digits
    has_strong_attribute :last_four_digits
    has_strong_attribute :payment_method
    has_strong_attribute :security_code
    has_strong_attribute :issuer
    has_strong_attribute :cardholder
    has_strong_attribute :date_created
    has_strong_attribute :date_last_updated

    before_api_request { set_param :access_token, MercadoPago::Settings.ACCESS_TOKEN }

  end
end
