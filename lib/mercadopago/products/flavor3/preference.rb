module MercadoPago
  class Preference < ActiveREST::Base

    #   Not allow dynamic attributes
    not_allow_dynamic_attributes

    attr_accessor :user_token
    
    has_rest_method create: '/checkout/preferences'
    has_rest_method read:   '/checkout/preferences/:id'
    has_rest_method update: '/checkout/preferences/:id'

    #   Setting the strong attributes
    has_strong_attribute :auto_return,          valid_values: ["approved", "all"]
    has_strong_attribute :back_urls,            type: Hash
    has_strong_attribute :id,                   type: String,    read_only: true,   primary_key: true
    has_strong_attribute :init_point,           type: String,    read_only: true
    has_strong_attribute :sandbox_init_point,   type: String,    read_only: true
    has_strong_attribute :operation_type,       type: String,    read_only: true
    has_strong_attribute :additional_info,      type: String,    length: 600
    has_strong_attribute :external_reference,   type: String,    length: 256
    has_strong_attribute :notification_url,     type: String,    length: 500
    has_strong_attribute :expires,              valid_values:    [true, false]
    has_strong_attribute :expiration_date_from, type: Date
    has_strong_attribute :expiration_date_to,   type: Date
    has_strong_attribute :collector_id,         type: Integer,   read_only: true
    has_strong_attribute :client_id,            type: Integer,   read_only: true
    has_strong_attribute :marketplace,          type: String
    has_strong_attribute :marketplace_fee,      type: Float
    has_strong_attribute :differential_pricing, type: Hash
    has_strong_attribute :payment_methods,      type: Hash
    has_strong_attribute :items,                type: Array,     required: true
    has_strong_attribute :payer,                type: Object


    before_api_request {  
      if self.user_token.nil? || self.user_token.empty? 
        set_param :access_token, MercadoPago::Settings.ACCESS_TOKEN
      else  
        set_param :access_token, self.user_token
      end
    }

    # Custom Behavior
    def save
      super do |response|
        # Only for Demo
        #=================
          file = File.open(File.expand_path(__dir__) + "/../sample/preference.json", "w+")
          file.puts(response)
          file.close
        #=================
      end
    end



  end
end
