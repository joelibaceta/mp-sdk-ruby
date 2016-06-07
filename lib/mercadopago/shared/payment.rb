module MercadoPago
  class Payment < ActiveREST::Base

    #   Algorithms avaiblables
    #   SHA256, SHA384, SHA512, HMAC, SHA1, RMD160, MD5
    #
    set_idempotency_algorithm 'SHA256'

    has_rest_method create: '/v1/payments/', idempotency: true
    has_rest_method read:   '/collections/notifications/:id'
    has_rest_method search: '/payments/search'
    has_rest_method update: '/payments/id'

    # For flavor 3
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
    has_strong_attribute :transaction_amount, type: Float
    has_strong_attribute :shipping_cost
    has_strong_attribute :total_paid_amount
    has_strong_attribute :finance_charge
    has_strong_attribute :net_received_amount
    has_strong_attribute :marketplace
    has_strong_attribute :marketplace_fee
    has_strong_attribute :reason
    has_strong_attribute :payer
    has_strong_attribute :collector

    # For flavor 1
    has_strong_attribute :transaction_details
    has_strong_attribute :fee_details
    has_strong_attribute :differential_pricing_id
    has_strong_attribute :application_fee
    has_strong_attribute :capture
    has_strong_attribute :captured
    has_strong_attribute :call_for_authorize_id
    has_strong_attribute :statement_descriptor
    has_strong_attribute :refunds
    has_strong_attribute :additional_info
    has_strong_attribute :campaign_id
    has_strong_attribute :coupon_amount
    has_strong_attribute :installments, type: Integer
    has_strong_attribute :token

    before_api_request { set_param :access_token, MercadoPago::Settings.ACCESS_TOKEN }


    def self.all # Overwritting all method
      super do |payment_list|
        if payment_list.empty?
          files = Dir["#{File.expand_path(__dir__)}/../dumps/*.payment"]
          files.each do  |file|
            file = File.open(file)
            MercadoPago::Notification.load_from_binary_file(file)
            file.close
          end
        end
      end
    end

  end
end
