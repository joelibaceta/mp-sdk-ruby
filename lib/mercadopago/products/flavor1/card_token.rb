module MercadoPago
  class CardToken < ActiveREST::Base



    has_rest_method create: '/v1/card_tokens?public_key=:public_key'
    has_rest_method read:   '/v1/card_tokens?public_key=:public_key'
    has_rest_method update: '/v1/card_tokens?public_key=:public_key'

    has_strong_attribute :public_key
    has_strong_attribute :card_id
    has_strong_attribute :first_six_digits
    has_strong_attribute :luhn_validation
    has_strong_attribute :date_used
    has_strong_attribute :status
    has_strong_attribute :date_due
    has_strong_attribute :live_mode
    has_strong_attribute :card_number_length
    has_strong_attribute :id
    has_strong_attribute :security_code_length
    has_strong_attribute :expiration_year
    has_strong_attribute :expiration_month
    has_strong_attribute :date_last_updated
    has_strong_attribute :last_four_digits
    has_strong_attribute :cardholder
    has_strong_attribute :date_created

  end
end