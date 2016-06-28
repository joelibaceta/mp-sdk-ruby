require 'yaml'
require 'logger'

module MercadoPago
  module Settings 

    # Default Configuration
    @@config = { 
        base_url:   "https://api.mercadopago.com",
        CLIENT_ID:      "",    CLIENT_SECRET:  "",
        ACCESS_TOKEN:   "",    REFRESH_TOKEN:  "",
        APP_ID:         "",
        sandbox_mode: true
    }
    
    def self.configuration
      result = Hash.new
      @@config.map{|k, v| (result[k] = v) if @@config[k] != ""}
      return result
    end

    @valid_config_keys = @@config.keys

    # Configure using hash
    def self.configure(opts = {})
      opts.each {|k,v| @@config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
    end

    # Configure through yaml file
    def self.configure_with(path_to_yaml_file)
      begin
        config = YAML::load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
        log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
      rescue Psych::SyntaxError
        log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
      end
      configure(config)
    end



    def self.try_to_get_token
      data  = {  grant_type:    'client_credentials',
                 client_id:     @@config[:CLIENT_ID],
                 client_secret: @@config[:CLIENT_SECRET]  }
      return MercadoPago::RESTClient.post("/oauth/token", data.to_json, {}, {})
    end

    def self.refresh_credentials

    end

    # Method missing overwrite to allow call to keys in @config as a method
    def self.method_missing(method, *args, &block)
      has_equal_operator = (method[-1] == '=')
      value = (has_equal_operator ? @@config[method[0..-2].to_sym] : @@config[method.to_sym]) rescue nil
      
      unless value.nil?
        if has_equal_operator
          @@config[method[0..-2].to_sym] = args[0]

          if (@@config[:CLIENT_ID] && @@config[:CLIENT_SECRET])
            response = try_to_get_token
            if (response)
              @@config[:ACCESS_TOKEN]   = response["access_token"]
              @@config[:REFRESH_TOKEN]  = response["refresh_token"]
            end
          end

        else
          return value
        end
      end

    end

  end
end
 