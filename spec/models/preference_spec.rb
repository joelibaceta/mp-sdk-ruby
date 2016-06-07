require_relative '../rspec_helper'

describe MercadoPago do
  context "Preference" do

    it "get all" do
      expect(MercadoPago::Preference.all.class).to eql(Array)
    end

    it "create preference with full data manually" do

      Faker::Config.locale = 'en-US'

      preference = MercadoPago::Preference.new

      preference.collector_id="202809963"
      preference.operation_type="regular_payment"
      preference.auto_return="approved"

      item1 = MercadoPago::Item.new
      item2 = MercadoPago::Item.new

      item1.id = "item-ID-1234"
      item1.title = Faker::Commerce.product_name
      item1.description = Faker::Lorem.sentence
      item1.category_id = "art"
      item1.picture_url = Faker::Avatar.image
      item1.currency_id = "ARS"
      item1.quantity = Faker::Number.between(1, 10)
      item1.unit_price = Faker::Commerce.price

      item2.id = "item-ID-4321"
      item2.title = Faker::Commerce.product_name
      item2.description = Faker::Lorem.sentence
      item2.category_id = "art"
      item2.picture_url = Faker::Avatar.image
      item2.currency_id = "ARS"
      item2.quantity = Faker::Number.between(1, 10)
      item2.unit_price = Faker::Commerce.price

      preference.items = [item1, item2]

      payer = MercadoPago::Payer.new

      payer.name = Faker::Name.first_name
      payer.surname = Faker::Name.last_name
      payer.email = Faker::Internet.free_email
      payer.date_created = Faker::Date.forward(5)

      payer.phone = { "area_code" => Faker::PhoneNumber.area_code,
                      "number" => Faker::PhoneNumber.cell_phone}

      payer.identification = { "type" => "DNI",
                               "number" => "12345678" }

      payer.address = { "street_name" => Faker::Address.street_name,
                        "street_number" => Faker::Address.building_number,
                        "zip_code" => Faker::Address.zip_code }


      preference.payer = payer

      #puts MercadoPago::Preference.friendly_print_structure
      puts preference.to_json
    end

    it "create preference with wrong data " do
      preference = MercadoPago::Preference.new
      preference.id = "ID-0000-0000-000000"

    end

    it "populate from rest" do

    end



  end
end
