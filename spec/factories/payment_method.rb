FactoryGirl.define do
  factory :valid_payment_method, class: MercadoPagoBlack::PaymentMethod do
    excluded_payment_methods [{}]
    excluded_payment_types [{}]
  end
end
