module MercadoPago
  class Customer < ActiveREST::Base
    
    has_rest_method read:   '/v1/customers/:id'
    has_rest_method search: '/v1/customers/search'
    has_rest_method create: '/v1/customers/'
    has_rest_method update: '/v1/customers/:id'
    has_rest_method remove: '/v1/customers/:id'

    has_strong_attribute :id
    has_strong_attribute :email,                   primary_key: true
    has_strong_attribute :first_name
    has_strong_attribute :last_name
    has_strong_attribute :phone
    has_strong_attribute :identification
    has_strong_attribute :default_address
    has_strong_attribute :address
    has_strong_attribute :date_registered
    has_strong_attribute :description
    has_strong_attribute :date_created
    has_strong_attribute :date_last_updated
    has_strong_attribute :metadata
    has_strong_attribute :default_card
    has_strong_attribute :cards
    has_strong_attribute :addresses

    before_api_request { set_param :access_token, MercadoPago::Settings.ACCESS_TOKEN }
    
    

  end
end