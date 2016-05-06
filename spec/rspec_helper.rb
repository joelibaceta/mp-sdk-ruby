
require 'factory_girl'
require 'support/fake_api_hub'
require_relative '../lib/mercadopago'
require 'faker'

require 'webmock/rspec'
require 'active_support'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  # Use color in STDOUT
  config.color = true
  FactoryGirl.find_definitions

  config.before(:each) do
    stub_request(:any, /api.mercadopago.com/).to_rack(FakeAPIHub)
  end

end

def with_default_api_configuration
  MercadoPagoBlack::Settings.configure({base_url: "https://api.mercadopago.com"})
end

def valid_items(n)
  items = Array.new
  (1..n).each do |i|
    items << valid_item
  end
  return items
end



def random_category
  "random"
end