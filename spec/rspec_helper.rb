require 'factory_girl'
require_relative '../lib/mercadopago'
require 'faker'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  # Use color in STDOUT
  config.color = true
  FactoryGirl.find_definitions
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