FactoryGirl.define do
  factory :valid_item, class: MercadoPagoBlack::Item do
    title Faker::Commerce.product_name
    currency_id "ARS"
    picture_url Faker::Avatar.image
    description Faker::Lorem.paragraph
    quantity Faker::Number.between(1, 10)
    unit_price Faker::Commerce.price
  end

end
