FactoryGirl.define do
  factory :valid_payment_method, class: MercadoPago::PaymentMethod do
    excluded_payment_methods [{}]
    excluded_payment_types [{}]
  end
end
