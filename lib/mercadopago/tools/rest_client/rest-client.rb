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

    def request(options={})
      
      # call:
      #
      #   get: '/slug/method' | post: '/path/ ...
      #
      
      method, request_path  = options.first
      verb                  = VERB_MAP[method]
      headers               =  options[:headers]
      url_query             =  options[:url_query]
      form_data, json_data  =  options[:form_data], options[:json_data]  
      default_http_params   = @@default_connection
      
      connection_params     = default_http_params #.merge(custom_http_params) rescue {}
      query                 = url_query.map{|name, value| "#{name}=#{value}"}.join("&") if url_query
      uri                   = URI.parse("#{connection_params[:address]}#{request_path}?#{query}") 
      http                  = Net::HTTP.new(uri.host, uri.port) 
      header                = {'Content-Type' =>'application/json'} 
      
      addr, port            = connection_params[:proxy_addr], connection_params[:proxy_port]
      http.use_ssl          = connection_params[:use_ssl]     if connection_params[:use_ssl]
      http.ssl_version      = connection_params[:ssl_version] if connection_params[:ssl_version]
      http.verify_mode      = connection_params[:verify_mode] if connection_params[:verify_mode]
      http.ca_file          = connection_params[:ca_file]     if connection_params[:ca_file]

      request               = addr.to_s != "" ? verb.new(uri, header, addr, port) : verb.new(uri, header)

      headers.each { |field, value| request.add_field(field, value) } if headers
      
      data                  = URI.encode_www_form(form_data)  if form_data
      data                  = json_data                       if json_data
      request.body          = data                            if data != {} 
      response              = http.request(request) 
      body                  = response.body
      
      #puts "http Request: #{verb}, Path: #{request_path}, Url_params: #{url_query}, Form_params: #{data}, uri: #{uri}"
      
      if response.code.to_s == "200" || response.code.to_s == "201"
        body = response.body.class     == Hash ? response.body : JSON.parse(response.body) rescue Hash.new
      else
        warn body
      end
      
      return {code: response.code, message: response.message, body: body} 
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

    def delete(slug, options={})
      request({:delete => slug}.merge(options))
    end
    module_function :delete
    
    def get(slug, options={})
      request({:get => slug}.merge(options))
    end
    module_function :get

    def post(slug, options={})
      request({:post => slug}.merge(options))
    end
    module_function :post
    
    def put(slug, options={})
      request({:put => slug}.merge(options))
    end
    module_function :put

  end

   
end
