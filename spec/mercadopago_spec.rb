require_relative 'rspec_helper'

describe MercadoPago do
  context "Environment Setup" do

    it "with default settings" do
      expect(MercadoPago::Settings.base_url).to eql("api.mercadopago.com")
      expect(MercadoPago::Settings.sandbox_mode).to eql(true)
      expect(MercadoPago::Settings.CLIENT_ID).to eql("")
      expect(MercadoPago::Settings.CLIENT_SECRET).to eql("")
      expect(MercadoPago::Settings.ACCESS_TOKEN).to eql("")
    end

    it "should have default settings after a wrong setup" do
      MercadoPago::Settings.configure({base_url_wrong: "https://custom.com"})
      expect(MercadoPago::Settings.base_url).to eql("api.mercadopago.com")
    end

    it "should have default settings after a wrong setup from YAML file" do
      MercadoPago::Settings.configure_with("./spec/settings_wrong.yml")
      expect(MercadoPago::Settings.base_url).to eql("api.mercadopago.com")
    end

    it "with custom settings from hash" do
      MercadoPago::Settings.configure({ base_url: "https://custom.com",
                                        CLIENT_ID: "RANDOM_ID",
                                        CLIENT_SECRET: "RANDOM_SECRET",
                                        ACCESS_TOKEN: "RANDOM_TOKEN" })

      expect(MercadoPago::Settings.base_url).to eql("https://custom.com")
      expect(MercadoPago::Settings.CLIENT_ID).to eql("RANDOM_ID")
      expect(MercadoPago::Settings.CLIENT_SECRET).to eql("RANDOM_SECRET")
      expect(MercadoPago::Settings.ACCESS_TOKEN).to eql("RANDOM_TOKEN")
      MercadoPago::Settings.base_url = "api.mercadopago.com"
    end

    it "with custom settings from Yaml file" do
      MercadoPago::Settings.configure_with("./spec/settings.yml")
      expect(MercadoPago::Settings.CLIENT_ID).to eql("CLIENT_ID_YAML")
      expect(MercadoPago::Settings.CLIENT_SECRET).to eql("CLIENT_SECRET_YAML")
      expect(MercadoPago::Settings.ACCESS_TOKEN).to eql("CLIENT_ACCESS_TOKEN_YAML")
      MercadoPago::Settings.base_url = "api.mercadopago.com"
    end

    it "should raise NoMethodError when require value from wrong key " do
      begin
        MercadoPago::Settings.wrong_param
      rescue => error
        expect(error.class).to eql(NoMethodError)
      end
    end
  end

  context "User Setup" do

    it "for a Basic Setup" do
      MercadoPago::Settings.ACCESS_TOKEN = "ACCESS_TOKEN"
      expect(MercadoPago::Settings.ACCESS_TOKEN).to eql("ACCESS_TOKEN")
    end

    it "for a Advanced Setup" do
      MercadoPago::Settings.CLIENT_ID = "CLIENT_ID"
      MercadoPago::Settings.CLIENT_SECRET = "CLIENT_SECRET"
      expect(MercadoPago::Settings.CLIENT_ID).to eql("CLIENT_ID")
      expect(MercadoPago::Settings.CLIENT_SECRET).to eql("CLIENT_SECRET")
    end

  end

end