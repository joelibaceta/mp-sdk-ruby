require_relative 'spec_helper'
require 'tempfile'

describe MercadoPago do

  context "Environment Setup" do

    it "Should return empty strings and mercadopago default base_url" do
      expect(MercadoPago::Settings.base_url).to       eql("https://api.mercadopago.com")
      expect(MercadoPago::Settings.CLIENT_ID).to      eql("")
      expect(MercadoPago::Settings.CLIENT_SECRET).to  eql("")
      expect(MercadoPago::Settings.ACCESS_TOKEN).to   eql("")
      expect(MercadoPago::Settings.REFRESH_TOKEN).to  eql("")
      expect(MercadoPago::Settings.APP_ID).to         eql("")
    end

    it "Should have default settings after to try with a wrong setup" do
      MercadoPago::Settings.configure({base_url_wrong: "https://custom.com"})
      expect(MercadoPago::Settings.base_url).to eql("https://api.mercadopago.com")
    end

    it "Should have default settings after a wrong setup from a YAML file" do
      temp_file = Tempfile.new('wrong.yml')
      MercadoPago::Settings.configure_with("temp_file")
      expect(MercadoPago::Settings.base_url).to eql("https://api.mercadopago.com")
    end

    it "With custom settings from hash" do
      MercadoPago::Settings.configure({
                                          base_url:       "https://custom.com",
                                          CLIENT_ID:      "RANDOM_ID",
                                          CLIENT_SECRET:  "RANDOM_SECRET",
                                          APP_ID:         "APP_ID",
                                          ACCESS_TOKEN:   "RANDOM_TOKEN",
                                          REFRESH_TOKEN:  "REFRESH_TOKEN"
                                      })

      expect(MercadoPago::Settings.base_url).to       eql("https://custom.com")
      expect(MercadoPago::Settings.CLIENT_ID).to      eql("RANDOM_ID")
      expect(MercadoPago::Settings.CLIENT_SECRET).to  eql("RANDOM_SECRET")
      expect(MercadoPago::Settings.APP_ID).to         eql("APP_ID")
      expect(MercadoPago::Settings.ACCESS_TOKEN).to   eql("RANDOM_TOKEN")
      expect(MercadoPago::Settings.REFRESH_TOKEN).to  eql("REFRESH_TOKEN")

      MercadoPago::Settings.base_url = "https://api.mercadopago.com"
    end

    it "with custom settings from Yaml file" do
      MercadoPago::Settings.configure_with("./spec/settings.yml")

      expect(MercadoPago::Settings.CLIENT_ID).to        eql("CLIENT_ID_YAML")
      expect(MercadoPago::Settings.CLIENT_SECRET).to    eql("CLIENT_SECRET_YAML")
      expect(MercadoPago::Settings.ACCESS_TOKEN).to     eql("CLIENT_ACCESS_TOKEN_YAML")
      expect(MercadoPago::Settings.REFRESH_TOKEN).to    eql("REFRESH_ACCESS_TOKEN_YAML")

      MercadoPago::Settings.base_url = "https://api.mercadopago.com"
    end

    it "should raise NoMethodError when require value from wrong key " do
      begin
        MercadoPago::Settings.wrong_param
      rescue => error
        expect(error.class).to eql(NoMethodError)
      end
    end

  end

  context "Setting up Credentials" do

    it "Setting invalid basic credentials" do
      MercadoPago::Settings.CLIENT_ID     = "WRONG_CLIENT_ID"
      MercadoPago::Settings.CLIENT_SECRET = "WRONG_CLIENT_SECRET"

      expect(MercadoPago::Settings.ACCESS_TOKEN).to  eql(nil)
    end

    it "Setting valid basic credentials" do
      MercadoPago::Settings.CLIENT_ID     = "CLIENT_ID"
      MercadoPago::Settings.CLIENT_SECRET = "CLIENT_SECRET"

      expect(MercadoPago::Settings.ACCESS_TOKEN).to  eql("ACCESS_TOKEN")
    end

    it "After to refresh credentials should can get the refreshed token" do
      MercadoPago::Settings.refresh_credentials
      expect(MercadoPago::Settings.ACCESS_TOKEN).to  eql("REFRESHED_TOKEN")
    end

    xit "Setting Custom Credentials" do
      MercadoPago::Settings.ACCESS_TOKEN = "TEST_ACCESS_TOKEN"
      expect(MercadoPago::Settings.ACCESS_TOKEN).to  eql("TEST_ACCESS_TOKEN")
    end

  end

  context "General Tests" do
    
    it "get_live_objects_as_html should return an html with the instance objects" do
      expect(MercadoPago.get_live_objects_as_html.class).to eql(String)
      expect(MercadoPago.get_live_objects_as_html).not_to eql("")
    end

    xit "should get mp connect url " do
      
      base_url         = "https://auth.mercadopago.com.ar/authorization"
      redirect_uri     = "http%3A%2Flocalhost%3A3000%2Fmp-connect-callback"
      query            = "client_id=APP_ID&response_type=code&platform_id=mp&redirect_uri=#{redirect_uri}"
      
      MercadoPago::Settings.APP_ID  = "APP_ID"
      expect(MercadoPago.mp_connect_link_path("http://localhost:3000")).to eql("#{base_url}?#{query}")
    end
    
  end
  

end