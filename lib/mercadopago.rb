require_relative 'mercadopago/settings' 
require_relative 'mercadopago/active_rest/lib/active_rest'
require_relative 'mercadopago/flavor3/preference'
require_relative 'mercadopago/item'
require_relative 'mercadopago/payer'
require_relative 'mercadopago/payment_method'
require_relative 'mercadopago/shipment'
require_relative 'mercadopago/identification_type'

module MercadoPago

  ActiveREST::RESTClient.config do
    http_param :address, MercadoPago::Settings.base_url
    http_param :use_ssl, true
    #http_param :ssl_version, :TLSv1
    #http_param :verify_mode, (OpenSSL::SSL::VERIFY_PEER)
    #http_param :ca_file, File.dirname(__FILE__) + '/mercadopago/ca-certificates.crt'
  end
  
  def manange_notificatons
    
  end

end

