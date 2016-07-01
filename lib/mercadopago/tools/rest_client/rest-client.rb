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

    @@default_connection ||= Hash.new

    def self.included(base)
      base.class_variable_set("@@http_connection", Hash.new) # Create a class in the including class
    end

    def request(verb, slug, url_params={}, data={}, headers={})

      default_http_params   = @@default_connection
      #custom_http_params    = _class.class_variable_get("@@http_connection") rescue {}
      connection_params     = default_http_params#.merge(custom_http_params) rescue {}

      str_url_params = url_params.map{|name, value| "#{name}=#{value}"}.join("&")

      uri = URI.parse("#{connection_params[:address]}#{slug}?#{str_url_params}")
      
      http = Net::HTTP.new(uri.host, uri.port)
      header = {'Content-Type' =>'application/json'}

      addr, port = connection_params[:proxy_addr], connection_params[:proxy_port]

      puts "http request Method: #{verb}, Path: #{slug}, Url_params: #{str_url_params}, Form_params: #{data}, uri: #{uri}"

      http.use_ssl      = connection_params[:use_ssl]     if connection_params[:use_ssl]
      http.ssl_version  = connection_params[:ssl_version] if connection_params[:ssl_version]
      http.verify_mode  = connection_params[:verify_mode] if connection_params[:verify_mode]
      http.ca_file      = connection_params[:ca_file]     if connection_params[:ca_file]

      request = addr.to_s != "" ? VERB_MAP[verb].new(uri, header, addr, port) : VERB_MAP[verb].new(uri, header)

      headers.each { |field, value| request.add_field(field, value) }
      
      data              = data.class              == Hash ? URI.encode_www_form(data) : data
      request.body      = data                    if data != {}
      response          = http.request(request)
      body              = response.body.class     == Hash ? response.body : JSON.parse(response.body)
      

      if !(response.is_a?(Net::HTTPSuccess))
        return {code: response.code, message: response.message, body: body}
      else
        return {code: response.code, message: response.message, body: body}
      end
    end
    module_function :request

    #def set_http_param(param, value)
    #  http_conn = self.class.class_variable_get("@@http_connection") rescue self.class.class_variable_set("@@http_connection", Hash.new)
    #  http_conn[param] = value
    #  self.class.class_variable_set("@@http_connection", http_conn)
    #end
    #module_function :set_http_param

    def http_param(param, value)
      @@default_connection[param] = value
    end
    module_function :http_param

    def config(&block)
      instance_eval &block
    end
    module_function :config

    def delete(slug, params={}, headers={})
      request(:delete, slug, params, {}, headers)
    end
    module_function :delete
    
    def get(slug, params={}, headers={})
      request(:get, slug, params, {}, headers)
    end
    module_function :get

    def post(slug, data, get_params={}, headers={})
      request(:post, slug, get_params, data, headers)
    end
    module_function :post
    
    def put(slug, data, get_params={}, headers={})
      request(:put, slug, get_params, data, headers)
    end
    module_function :put

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
