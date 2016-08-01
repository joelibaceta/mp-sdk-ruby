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

CodeClimate::TestReporter.configure do |config|
  config.logger.level = Logger::WARN
end

SimpleCov.start

CodeClimate::TestReporter::Formatter.new.format(SimpleCov.result)

CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.color = true
  config.before(:each) do
    stub_request(:any, /https:\/\/api.mercadopago.com/).to_rack(FakeAPIHub)
    stub_request(:any, /http:\/\/api.mercadopago.com:443/).to_rack(FakeAPIHub)
  end
  FactoryGirl.find_definitions
end

def with_default_api_configuration
  MercadoPago::Settings.configure({base_url: "https://api.mercadopago.com"})
end
