require 'net/http'
require 'uri'
require 'json'

module MercadoPago
  module RESTClient

    VERB_MAP = {
        :get    => Net::HTTP::Get,
        :post   => Net::HTTP::Post,
        :put    => Net::HTTP::Put,
        :delete => Net::HTTP::Delete
    }

    @@default_connection = Hash.new

    def self.included(base)
      base.class_variable_set("@@http_connection", Hash.new) # Create a class in the including class
    end

    def request(verb, slug, url_params={}, data={}, headers={}, _class)
      default_http_params, custom_http_params = @@default_connection, _class.class_variable_get("@@http_connection")
      connection_params                       = default_http_params.merge!(custom_http_params)

      str_url_params = url_params.map{|name, value| "#{name}=#{value}"}.join("&")

      uri = URI("#{connection_params[:address]}#{slug}?#{str_url_params}")

      puts "http request Method: #{verb}, Path: #{slug}, Url_params: #{url_params}, Form_params: #{data}, uri: #{uri}"

      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl      = connection_params[:use_ssl]     if connection_params[:use_ssl]
      http.ssl_version  = connection_params[:ssl_version] if connection_params[:ssl_version]
      http.verify_mode  = connection_params[:verify_mode] if connection_params[:verify_mode]
      http.ca_file      = connection_params[:ca_file]     if connection_params[:ca_file]

      p "REQUEST: #{@@default_connection}"

      request = VERB_MAP[verb].new(uri, {'Content-Type' =>'application/json'})

      if connection_params[:proxy_addr].to_s != ""
        request = VERB_MAP[verb].new(uri, {'Content-Type' =>'application/json'}, connection_params[:proxy_addr], connection_params[:proxy_port])
      end


      request = VERB_MAP[verb].new(uri, {'Content-Type' =>'application/json'})

      headers.each do |field, value|
        request.add_field(field, value)
      end

      request.body = data if data != {}
      response = http.request(request)

      if !(response.is_a?(Net::HTTPSuccess))
        warn response.body
        raise response.body
      else
        return JSON.parse(response.body)
      end
    end

    def set_http_param(param, value)
      http_conn = self.class.class_variable_get("@@http_connection") rescue self.class.class_variable_set("@@http_connection", Hash.new)
      http_conn[param] = value
      self.class.class_variable_set("@@http_connection", http_conn)
    end
    module_function :set_http_param

    def http_param(param, value)
      puts "HTTP_PARAM"
      @@default_connection[param] = value
    end
    module_function :http_param

    def config(&block)
      instance_eval &block
    end
    module_function :config



    def delete(slug, params={}, headers={},_class=self)
      request(:delete, slug, params, {}, headers={},_class)
    end
    def get(slug, params={}, headers={}, _class=self)
      request(:get, slug, params, {}, headers={},_class)
    end

    def post(slug, data, get_params={}, headers={}, _class=self)
      request(:post, slug, get_params, data, headers={},_class)
    end
    def put(slug, data, get_params={}, headers={}, _class=self)
      request(:put, slug, get_params, data, headers={},_class)
    end

  end

  class RestError < StandardError
    def initialize(msg=nil)
      @message = msg
      puts @message
    end

    def message
      @message
    end

  end
end
