require_relative '../rspec_helper'

describe MercadoPagoBlack do
  context "PaymentMethod" do

    it "get the list method url" do
      expect(MercadoPagoBlack::PaymentMethod.list_url).to eql("/v1/payment_methods")
    end

    it "populate from API" do
      MercadoPagoBlack::Settings.configure({base_url: "https://api.mercadopago.com"})
      MercadoPagoBlack::PaymentMethod.populate_from_api
      expect(MercadoPagoBlack::PaymentMethod.first.class).to eql(MercadoPagoBlack::PaymentMethod)
    end

  end
end