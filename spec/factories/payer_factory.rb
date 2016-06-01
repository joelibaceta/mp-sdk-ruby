FactoryGirl.define do

  factory :valid_payer, class: MercadoPago::Payer do
    name Faker::Name.first_name
    surname Faker::Name.last_name
    email Faker::Internet.email
    phone ({area_code: Faker::PhoneNumber.area_code,
                    number: Faker::PhoneNumber.phone_number})
    identification new Hash({type: FactoryGirl.build(:valid_identification_type).name,
                             number: Faker::Number.number(8)})
    address ({zip_code: Faker::Address.zip_code,
                      street_name: Faker::Address.street_name,
                      street_number: Faker::Address.building_number})
    date_created Faker::Date.backward(3).strftime("%FT%T.%L%z")

  end

  factory :valid_payer_with_minimal_data,  class: MercadoPago::Payer do
    name Faker::Name.first_name
    surname Faker::Name.last_name
    email Faker::Internet.email
  end

end
