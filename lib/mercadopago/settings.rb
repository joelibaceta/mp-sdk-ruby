require 'yaml'
require 'logger'

module MercadoPago
  module Settings 

    # Default Configuration
    #
    @@config = { 
        base_url:       "https://api.mercadopago.com",
        CLIENT_ID:      "",    CLIENT_SECRET:  "",
        ACCESS_TOKEN:   "",    REFRESH_TOKEN:  "",
        APP_ID:         ""
    }
    
    def self.configuration
      @@config.map{|k, v| {:k => v} if @@config[k] != ""}.reduce({}, :merge)
    end

    @valid_config_keys = @@config.keys

    # Configure using hash
    #
    def self.configure(opts = {})
      opts.each {|k,v| @@config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
    end

    # Configure through yaml file
    def self.configure_with(yaml)
      begin;  configure(YAML::load(yaml.class == String ? IO.read(yaml) : yaml.read))
      rescue; log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
      rescue; log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
      end
    end

    #
    def self.try_to_get_token
      if (@@config[:CLIENT_ID].to_s != "" && @@config[:CLIENT_SECRET].to_s != "")
        data  = {
          grant_type:    'client_credentials',
          client_id:     @@config[:CLIENT_ID],
          client_secret: @@config[:CLIENT_SECRET]
        }
        return MercadoPago::RESTClient.post("/oauth/token", json_data: data.to_json).body
      else
        return nil
      end
    end

    #
    def self.refresh_credentials
      data  = {
          grant_type:    'refresh_token',
          client_id:     @@config[:CLIENT_ID],
          refresh_token: @@config[:REFRESH_TOKEN]
      }
      response = MercadoPago::RESTClient.post("/oauth/token", json_data: data.to_json).body

      if response["access_token"]
        @@config[:ACCESS_TOKEN] = response["access_token"]
      end

    end

    # Method missing overwrite to allow call to keys in @config as a method
    #
    def self.method_missing(method, *args, &block)
      has_equal_operator = (method[-1] == '=')
      value = (has_equal_operator ? @@config[method[0..-2].to_sym] : @@config[method.to_sym]) rescue nil
      
      unless value.nil?
        if has_equal_operator
          @@config[method[0..-2].to_sym] = args[0]
          response = try_to_get_token
          @@config[:ACCESS_TOKEN]  = response["access_token"]  if response
          @@config[:REFRESH_TOKEN] = response["refresh_token"] if response
        else
          return value
        end
      end
    end

  end
end