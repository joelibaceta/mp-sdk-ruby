require_relative '../rspec_helper'

describe MercadoPago do
  context "PaymentMethod" do

    it "get the list method url" do
      expect(MercadoPago::PaymentMethod.list_url).to eql("/v1/payment_methods")
    end

    it "populate from API" do
      MercadoPago::Settings.configure({base_url: "https://api.mercadopago.com"})
      MercadoPago::PaymentMethod.populate_from_api
      expect(MercadoPago::PaymentMethod.first.class).to eql(MercadoPago::PaymentMethod)
    end

  end
end