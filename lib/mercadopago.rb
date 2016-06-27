require 'active_support/inflector'
require 'cgi'

Dir["#{File.dirname(__FILE__)}/mercadopago/tools/**/*.rb"].each { |f| load f }
require "#{File.dirname(__FILE__)}/mercadopago/active_rest/active_rest"
require "#{File.dirname(__FILE__)}/mercadopago/settings"
Dir["#{File.dirname(__FILE__)}/mercadopago/products/**/*.rb"].each { |f| load f }

module MercadoPago

  RESTClient.config do
    http_param :address, MercadoPago::Settings.base_url
    http_param :use_ssl, true
    http_param :ca_file, File.dirname(__FILE__) + '/mercadopago/ca-bundle.crt'
  end

  def mp_connect_link_path(root)
    str_link  = 'https://auth.mercadopago.com.ar/authorization?client_id=APP_ID&response_type=code&platform_id=mp&redirect_uri=REDIRECT_URI'
    str_link  = str_link.gsub("APP_ID",       MercadoPago::Settings.APP_ID)
    str_link  = str_link.gsub("REDIRECT_URI", CGI.escape("#{root}/mp-connect-callback"))
    return str_link
  end
  module_function :mp_connect_link_path

  # @return [String]
  def get_live_objects_as_html
    response = Hash.new
    Dir["#{File.dirname(__FILE__)}/mercadopago/products/**/*.rb"].each do |filename| 
      str_tree = filename[/.\/mercadopago\/products\/(.*?).rb/m, 1].split("/")
      response[str_tree[0].camelize] ||= Array.new
      response[str_tree[0].camelize].push(str_tree[1].camelize => eval("MercadoPago::#{str_tree[1].camelize}.all"))
    end
    return self.get_html_from_hash(response)
  end
  module_function :get_live_objects_as_html

  def get_html_from_hash(obj)
    klass, response = obj.class, ""
    case klass.to_s
      when "Array"; response += obj.map{|item| "<li>#{get_html_from_hash(item)}</li>"}.join("")
      when "Hash"; response += obj.map{|k, v| "<li>#{k}<ul>#{get_html_from_hash(v)}</ul></li>"}.join("")
      else; response += "<li>#{klass}##{obj.id rescue ""}</li>"
    end
    return response
  end
  module_function :get_html_from_hash

  

end

