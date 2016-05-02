require 'mercadopago.rb'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

$mp = MercadoPago.new('TEST-3964826791704277-042213-a8239945016c46f25a87aafebd74bab3__LD_LB__-202809963')