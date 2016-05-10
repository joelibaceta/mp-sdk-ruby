require 'mercadopago/settings' #Configuration
require 'mercadopago/active_rest/lib/active_rest'
require 'mercadopago/preference'
require 'mercadopago/item'
require 'mercadopago/payer'
require 'mercadopago/payment_method'
require 'mercadopago/shipment'
require 'mercadopago/identification_type'

module MercadoPagoBlack

  ActiveREST::RESTClient.config do
    http_param :address, MercadoPagoBlack::Settings.base_url
    http_param :use_ssl, true
    http_param :ssl_version, :TLSv1
    http_param :verify_mode, (OpenSSL::SSL::VERIFY_PEER)
    http_param :ca_file, File.dirname(__FILE__) + '/mercadopago/ca-certificates.crt'
  end

end