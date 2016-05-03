require_relative 'rspec_helper'
require_relative '../lib/mercadopago'

describe MercadoPagoBlack do
  context "Environment Setup" do

    it "with default settings" do
      expect(MercadoPagoBlack::Settings.base_url).to eql("https://api.mercadopago.com")
      expect(MercadoPagoBlack::Settings.sandbox_mode).to eql(true)
      expect(MercadoPagoBlack::Settings.CLIENT_ID).to eql("")
      expect(MercadoPagoBlack::Settings.CLIENT_SECRET).to eql("")
      expect(MercadoPagoBlack::Settings.ACCESS_TOKEN).to eql("")
    end

    it "should have default settings after a wrong setup" do
      MercadoPagoBlack::Settings.configure({base_url_wrong: "https://custom.com"})
      expect(MercadoPagoBlack::Settings.base_url).to eql("https://api.mercadopago.com")
    end

    it "should have default settings after a wrong setup from YAML file" do
      MercadoPagoBlack::Settings.configure_with("./spec/settings_wrong.yml")
      expect(MercadoPagoBlack::Settings.base_url).to eql("https://api.mercadopago.com")
    end

    it "with custom settings from hash" do
      MercadoPagoBlack::Settings.configure({base_url: "https://custom.com",
                                            CLIENT_ID: "RANDOM_ID",
                                            CLIENT_SECRET: "RANDOM_SECRET",
                                            ACCESS_TOKEN: "RANDOM_TOKEN"})

      expect(MercadoPagoBlack::Settings.base_url).to eql("https://custom.com")
      expect(MercadoPagoBlack::Settings.CLIENT_ID).to eql("RANDOM_ID")
      expect(MercadoPagoBlack::Settings.CLIENT_SECRET).to eql("RANDOM_SECRET")
      expect(MercadoPagoBlack::Settings.ACCESS_TOKEN).to eql("RANDOM_TOKEN")
    end

    it "with custom settings from Yaml file" do
      MercadoPagoBlack::Settings.configure_with("./spec/settings.yml")
      expect(MercadoPagoBlack::Settings.CLIENT_ID).to eql("CLIENT_ID_YAML")
      expect(MercadoPagoBlack::Settings.CLIENT_SECRET).to eql("CLIENT_SECRET_YAML")
      expect(MercadoPagoBlack::Settings.ACCESS_TOKEN).to eql("CLIENT_ACCESS_TOKEN_YAML")
    end

    it "should raise NoMethodError when require value from wrong key " do
      begin
        MercadoPagoBlack::Settings.wrong_param
      rescue => error
        expect(error.class).to eql(NoMethodError)
      end
    end

  end

  context "User Setup" do

    it "for a Basic Setup" do
      MercadoPagoBlack::Settings.ACCESS_TOKEN = "ACCESS_TOKEN"
      expect(MercadoPagoBlack::Settings.ACCESS_TOKEN).to eql("ACCESS_TOKEN")
    end

    it "for a Advanced Setup" do
      MercadoPagoBlack::Settings.CLIENT_ID = "CLIENT_ID"
      MercadoPagoBlack::Settings.CLIENT_SECRET = "CLIENT_SECRET"
      expect(MercadoPagoBlack::Settings.CLIENT_ID).to eql("CLIENT_ID")
      expect(MercadoPagoBlack::Settings.CLIENT_SECRET).to eql("CLIENT_SECRET")
    end

  end

end