require_relative '../rspec_helper'
require_relative '../../lib/mercadopago'

describe MercadoPagoBlack do
  context "Rest API" do
    it "get payments" do
      uri = URI(MercadoPagoBlack::Settings.base_url + '/v1/payment_methods')
      response = Net::HTTP.get(uri)
      expect(response[0]).to_not eql(nil)
    end
  end
end