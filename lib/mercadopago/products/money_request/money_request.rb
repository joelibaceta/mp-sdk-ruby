module MercadoPago
  class MoneyRequest < ActiveREST::Base

    has_rest_method create: '/money_requests'
    has_rest_method read:   '/money_requests/:id'
    has_rest_method update: '/money_requests/:id'
    
    has_strong_attribute :status
    has_strong_attribute :site_id
    has_strong_attribute :currency_id,          required: true
    has_strong_attribute :amount,               required: true
    has_strong_attribute :collector_id
    has_strong_attribute :collector_email
    has_strong_attribute :payer_id
    has_strong_attribute :payer_email,          required: true
    has_strong_attribute :description,          required: true
    has_strong_attribute :init_point
    has_strong_attribute :external_reference
    has_strong_attribute :concept_type,         required: true
    has_strong_attribute :pref_id,              primary_key: true
    
    before_api_request { set_param :access_token, MercadoPago::Settings.ACCESS_TOKEN }

  end
end