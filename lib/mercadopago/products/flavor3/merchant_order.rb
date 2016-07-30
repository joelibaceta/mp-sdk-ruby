
module MercadoPago
  class MerchantOrder < ActiveREST::Base
    
    has_rest_method read:   '/merchant_orders/:id'
    has_rest_method search: '/merchant_orders'
    has_rest_method update: '/merchant_orders/:id'
    
    has_strong_attribute :id,                 type: Integer,   read_only: true,                 primary_key: true
    has_strong_attribute :preference_id,      type: String
    has_strong_attribute :date_created,       read_only: true
    has_strong_attribute :last_update,        read_only: true
    has_strong_attribute :application_id,     type: String
    has_strong_attribute :status,             type: String
    has_strong_attribute :site_id,            type: String
    has_strong_attribute :payer,              type: Hash                  
    has_strong_attribute :collector,          type: Hash
    has_strong_attribute :sponsor_id,         type: Integer
    has_strong_attribute :payments,           type: Array
    has_strong_attribute :paid_amount,        type: Float
    has_strong_attribute :refunded_amount,    type: Float
    has_strong_attribute :shipping_cost,      type: Float
    has_strong_attribute :cancelled
    has_strong_attribute :items,              type: Array
    has_strong_attribute :shipments
    has_strong_attribute :notification_url,   type: String,    length: 500
    has_strong_attribute :additional_info,    type: String,    length: 600
    has_strong_attribute :external_reference, type: String,    length: 256
    has_strong_attribute :marketplace,        type: String,    length: 256
    has_strong_attribute :total_amount,       type: Float

    before_api_request { set_param :access_token, MercadoPago::Settings.ACCESS_TOKEN }

    def self.all # Overwritting all method
      super do |merchant_order_list|
        if merchant_order_list.empty?
          files = Dir["#{File.expand_path(__dir__)}/../dumps/*.merchant_order"]
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
