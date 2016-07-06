module MercadoPago 
  class Preapproval < ActiveREST::Base
    
    has_rest_method create: '/preapproval/'
    has_rest_method read: '/preapproval/:id'
    has_rest_method update: '/preapproval/:id'
    
    has_strong_attribute :payer_email
    has_strong_attribute :back_url
    has_strong_attribute :reason
    has_strong_attribute :external_reference
    
    # auto_recurring
    # 
    # { 
    #   frequency: 1, 
    #   frequency_type: 'months', 
    #   transaction_amount: 60, 
    #   currency_id: 'ARS', 
    #   start_date: '2014-12-10T14:58:11.778-03:00', 
    #   end_date: '2015-06-10T14:58:11.778-03:00'
    # }
    #
    has_strong_attribute :auto_recurring
    
    has_strong_attribute :payer_id
    has_strong_attribute :collector_id 
    has_strong_attribute :application_id
    has_strong_attribute :status
    has_strong_attribute :init_point
    has_strong_attribute :sandbox_init_point
    has_strong_attribute :preapproval_plan_id
    
      
  end
end