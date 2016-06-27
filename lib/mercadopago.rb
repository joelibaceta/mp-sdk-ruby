require 'active_support/inflector'


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

  # @return [String]
  def get_live_objects_as_html
    response = Hash.new
    Dir["#{File.dirname(__FILE__)}/mercadopago/products/**/*.rb"].each do |filename|
      puts "FILENAME: #{filename}"
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

