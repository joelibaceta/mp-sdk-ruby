require_relative '../rspec_helper'
require_relative '../../lib/mercadopago'

describe MercadoPago do
  context "Rest API" do
    xit "get payments" do
      uri = URI("https://#{MercadoPago::Settings.base_url}/v1/payment_methods")
      response = Net::HTTP.get(uri)
      expect(response[0]).to_not eql(nil)
    end
  end
end