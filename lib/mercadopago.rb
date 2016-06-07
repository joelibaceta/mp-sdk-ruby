require_relative 'mercadopago/settings' 
require_relative 'mercadopago/active_rest/lib/active_rest'
require_relative 'mercadopago/flavor3/preference'

require_relative 'mercadopago/shared/item'
require_relative 'mercadopago/shared/payer'
require_relative 'mercadopago/shared/payment_method'
require_relative 'mercadopago/shared/notification'
require_relative 'mercadopago/shared/payment'

require_relative 'mercadopago/flavor1/card_token'
require_relative 'mercadopago/flavor1/card'
require_relative 'mercadopago/flavor1/customer'

require_relative 'mercadopago/flavor3/merchant_order'

require_relative 'mercadopago/flavor3/shipment'

require_relative 'mercadopago/shared/identification_type'

module MercadoPago
 
  ActiveREST::RESTClient.config do
    http_param :address, MercadoPago::Settings.base_url
    http_param :use_ssl, true
    #http_param :ssl_version, :TLSv1
    #http_param :verify_mode, (OpenSSL::SSL::VERIFY_PEER)
    http_param :ca_file, File.dirname(__FILE__) + '/mercadopago/ca-certificates.crt'
  end
  
  def manange_notificatons

  end

  def get_objects
    response = {
      "Flavor1" => {
          "Customers"=> MercadoPago::Customer.all
      },
      "Flavor3" => {
          "Preference" => MercadoPago::Preference.all
      },
      "Shared" => {
          "Payments" => MercadoPago::Payment.all,
          "MerchantOrder" => MercadoPago::MerchantOrder.all,
          "Shipment" => MercadoPago::Shipment.all,
          "Card" => MercadoPago::Card.all,
          "Notification" => MercadoPago::Notification.all,
          "PaymentMethod" => MercadoPago::PaymentMethod.all
      }
    }
    return self.get_html_list_objects(response)
  end
  module_function :get_objects

  def get_html_list_objects(obj)
    response = ""
    klass = obj.class
    p "KLASS: #{klass}"
    case klass.to_s
      when "Array"
        response += obj.map{|item| "<li>#{get_html_list_objects(item)}</li>"}.join("")
      when "Hash"
        response += obj.map{|k, v| "<li>#{k}<ul>#{get_html_list_objects(v)}</ul></li>"}.join("")
      else
        response += "<li>#{klass}##{obj.id rescue ""}</li>"
    end
    return response;
  end
  module_function :get_html_list_objects

end

