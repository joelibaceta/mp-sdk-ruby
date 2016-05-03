require_relative '../rspec_helper'

describe MercadoPagoBlack do
  context "Preference" do

    it "get all" do
      expect(MercadoPagoBlack::Preference.all).to eql(Array.new)
    end

    it "create one" do
      #expect(MercadoPagoBlack::Preference.create().class).to eql(MercadoPagoBlack::Preference)
    end

    it "populate from rest" do

    end



  end
end
