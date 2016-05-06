require_relative '../rspec_helper'

describe MercadoPagoBlack do
  context "identification_type.rb" do

    it "get the list identification Type url" do
      expect(MercadoPagoBlack::IdentificationType.list_url).to eql("/v1/identification_types")
      MercadoPagoBlack::IdentificationType.populate_from_api
    end

    it "populate from API" do
      MercadoPagoBlack::Settings.configure({base_url: "https://api.mercadopago.com"})
      MercadoPagoBlack::IdentificationType.populate_from_api
      expect(MercadoPagoBlack::IdentificationType.first.class).to eql(MercadoPagoBlack::IdentificationType)
    end

  end
end