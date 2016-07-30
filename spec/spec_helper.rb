require 'rspec'
require 'simplecov'
require 'factory_girl'
require 'support/fake_api_hub'
require 'mercadopago'
require 'faker'
require 'colorize'
require 'webmock/rspec'
require 'active_support'
require 'mercadopago/mpmiddleware'
require "codeclimate-test-reporter"

CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  # Use color in STDOUT
  config.color = true

  FactoryGirl.find_definitions

  config.before(:each) do
    stub_request(:any, /https:\/\/api.mercadopago.com/).to_rack(FakeAPIHub)
    stub_request(:any, /http:\/\/api.mercadopago.com:443/).to_rack(FakeAPIHub)
  end
end

def with_default_api_configuration
  MercadoPago::Settings.configure({base_url: "https://api.mercadopago.com"})
end

def valid_items(n)
  items = Array.new
  (1..n).each do |i|
    items << valid_item
  end
  return items
end

def receive_a_merchant_order_notification

end

def receive_a_payment_notification

end


def random_category
  "random"
end