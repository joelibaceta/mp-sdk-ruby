FactoryGirl.define do
  factory :preference_with_valid_data, class: MercadoPago::Preference do
    notification_url      Faker::Internet.url
    external_reference    Faker::Lorem.word
    expires               Faker::Boolean.boolean
    expiration_date_from  Time.now
    expiration_date_to    Time.now + (2 * 24 * 60 * 60)
  end
end
