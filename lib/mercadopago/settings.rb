require 'yaml'
require 'logger'

module MercadoPagoBlack
  module Settings

    # Default Configuration
    @config = {
        base_url:       "https://api.mercadopago.com",
        sandbox_mode:   true,
        CLIENT_ID:      "",
        CLIENT_SECRET:  "",
        ACCESS_TOKEN:   ""
    }

    @valid_config_keys = @config.keys

    # Configure using hash
    def self.configure(opts = {})
      opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
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
      response = @config[method] rescue nil
      if response
        return response
      end
    end



  end
end
