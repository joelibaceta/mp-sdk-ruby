module MercadoPago
  class MoneyRequest < ActiveREST::Base

    has_rest_method list: '/money_requests'
    has_rest_method read: '/money_requests/:id'
    
    has_strong_attribute :status
    has_strong_attribute :site_id
    has_strong_attribute :currency_id 
    has_strong_attribute :amount
    has_strong_attribute :collector_id
    has_strong_attribute :collector_email
    has_strong_attribute :payer_id
    has_strong_attribute :payer_email 
    has_strong_attribute :description
    has_strong_attribute :init_point
    has_strong_attribute :external_reference
    has_strong_attribute :concept_type
    has_strong_attribute :pref_id
    
    before_api_request { set_param :access_token, MercadoPago::Settings.ACCESS_TOKEN }

  end
end