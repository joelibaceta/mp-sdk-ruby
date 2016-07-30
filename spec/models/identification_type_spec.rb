require_relative '../spec_helper'
require 'pp'

describe MercadoPago do
  context "identification_type.rb" do
    
    it "get the list identification Type url" do
      expect(MercadoPago::IdentificationType.list_url.url).to eql("/v1/identification_types")
      MercadoPago::IdentificationType.populate_from_api
    end
    
    it "populate from API" do
      MercadoPago::Settings.configure({base_url: "https://api.mercadopago.com"})
      MercadoPago::IdentificationType.populate_from_api
      expect(MercadoPago::IdentificationType.first.class).to eql(MercadoPago::IdentificationType) 
    end
    
  end
end