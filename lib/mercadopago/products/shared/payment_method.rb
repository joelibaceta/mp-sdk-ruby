module MercadoPago
  class PaymentMethod < ActiveREST::Base

    has_rest_method list: '/v1/payment_methods'

    has_strong_attribute :id,                 primary_key: true
    has_strong_attribute :name
    has_strong_attribute :payment_type_id
    has_strong_attribute :status
    has_strong_attribute :secure_thumbnail
    has_strong_attribute :thumbnail
    has_strong_attribute :deferred_capture
    has_strong_attribute :settings
    has_strong_attribute :additional_info_needed
    has_strong_attribute :min_allowed_amount
    has_strong_attribute :max_allowed_amount
    has_strong_attribute :accreditation_time

    # Other Attributes
    has_strong_attribute :excluded_payment_methods
    has_strong_attribute :excluded_payment_types
    has_strong_attribute :default_payment_method_id
    has_strong_attribute :installments
    has_strong_attribute :default_installments

    before_api_request { set_param :access_token, MercadoPago::Settings.ACCESS_TOKEN }

  end
end