require 'yaml'
require 'logger'

module MercadoPago
  module Settings

    # Default Configuration
    @@config = {
        base_url:       "api.mercadopago.com",
        sandbox_mode:   true,
        CLIENT_ID:      "",
        CLIENT_SECRET:  "",
        ACCESS_TOKEN:   "", 
        notification_url:   ""
    }
    
    def self.configuration
      result = Hash.new
      @@config.map{|k, v| (result[k] = v) if configuration[k] != ""}
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

    # Method missing overwrite to allow call to keys in @config as a method
    def self.method_missing(method, *args, &block)
      has_equal_operator = (method[-1] == '=')
      value = (has_equal_operator ? @@config[method[0..-2].to_sym] : @@config[method.to_sym]) rescue nil


      if value
        if has_equal_operator
          @@config[method[0..-2].to_sym] = args[0]

        else
          return value
        end
      end

    end

  end
end
 