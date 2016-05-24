module MercadoPago
  class Payment < ActiveREST::Base 
    
    has_rest_method read:   '/payments/:id'
    has_rest_method search: '/payments/search'
    has_rest_method update: '/payments/id'
    
    has_strong_attribute :id
    has_strong_attribute :site_id
    has_strong_attribute :operation_type
    has_strong_attribute :order_id
    has_strong_attribute :external_reference
    has_strong_attribute :status
    has_strong_attribute :status_detail
    has_strong_attribute :payment_type
    has_strong_attribute :date_created
    has_strong_attribute :last_modified
    has_strong_attribute :date_approved
    has_strong_attribute :money_release_date
    has_strong_attribute :currency_id
    has_strong_attribute :transaction_amount
    has_strong_attribute :shipping_cost
    has_strong_attribute :total_paid_amount
    has_strong_attribute :finance_charge
    has_strong_attribute :net_received_amount
    has_strong_attribute :marketplace
    has_strong_attribute :marketplace_fee
    has_strong_attribute :reason
    has_strong_attribute :payer
    has_strong_attribute :collector 
    
  end
end
