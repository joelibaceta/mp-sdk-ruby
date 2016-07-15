module MercadoPago
  class Payer  < ActiveREST::Base
    not_allow_dynamic_attributes

    # Setting the strong attributes
    has_strong_attribute :name,             type: String
    has_strong_attribute :surname,          type: String
    has_strong_attribute :email,            type: String,                 primary_key: true
    has_strong_attribute :date_created,     type: Date
    has_strong_attribute :phone,            type: Hash
    has_strong_attribute :identification,   type: Hash
    has_strong_attribute :address,           type: Hash

  end
end