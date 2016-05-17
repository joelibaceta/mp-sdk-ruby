require 'json'
require 'net/http'
require_relative 'http_connection'

module ActiveREST
  module RESTClient

    @@default_connection = Hash.new

    def config(&block)
      instance_eval &block
    end
    module_function :config

    def self.included(base)
      class_variable_get("@@http_connection") rescue self.class_variable_set("@@http_connection", Hash.new)
    end

    def set_http_param(param, value)
      http_conn = class_variable_get("@@http_connection") rescue self.class_variable_set("@@http_connection", Hash.new)
      http_conn[param] = value
      self.class_variable_set("@@http_connection", http_conn)
    end
    module_function :set_http_param

    def http_param(param, value)
        @@default_connection[param] = value

    end
    module_function :http_param

    def build_uri

    end

    def get(slug="", params={}, _class=self)
      default = @@default_connection
      custom = _class.class_variable_get("@@http_connection")
      mixed = default.merge!(custom)
      http = Net::HTTP.new(mixed[:address], mixed[:port])
      http.use_ssl = mixed[:use_ssl] if mixed[:use_ssl]
      http.ssl_version = mixed[:ssl_version] if mixed[:ssl_version]
      http.verify_mode = mixed[:verify_mode] if mixed[:verify_mode]
      http.ca_file = mixed[:ca_file] if mixed[:ca_file]

      req = Net::HTTP::Get.new(slug)

      response = http.request(req)
      return JSON.parse(response.body)
    end

    def post(slug="", data={}, _class=self) # TODO: Callback
      default = @@default_connection
      custom = _class.class_variable_get("@@http_connection")
      mixed = default.merge!(custom)


      http = Net::HTTP.new(mixed[:address], mixed[:port])
      http.use_ssl = mixed[:use_ssl] if mixed[:use_ssl]
      http.ssl_version = mixed[:ssl_version] if mixed[:ssl_version]
      http.verify_mode = mixed[:verify_mode] if mixed[:verify_mode]
      http.ca_file = mixed[:ca_file] if mixed[:ca_file]

      req = Net::HTTP::Post.new(slug, {'Content-Type' => 'application/json'})
      req.body = data
      response = http.request(req)

      return JSON.parse(response.body)
    end

    def put(slug, data, callback)

    end

    def delete(slug, params, callback)

    end

  end
end