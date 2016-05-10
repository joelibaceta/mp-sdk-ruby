FactoryGirl.define do

  id_array_mock = JSON.parse(File.read(File.dirname(__FILE__) + "/../fixtures/identification_types.json"))
  id_sample = id_array_mock.sample

  factory :valid_identification_type, class: MercadoPagoBlack::IdentificationType do
    id id_sample["id"]
    name id_sample["name"]
    type id_sample["type"]
    min_length id_sample["min_length"]
    max_length id_sample["max_length"]

  end
end