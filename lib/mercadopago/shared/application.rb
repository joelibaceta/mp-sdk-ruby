module MercadoPago
  class Application < ActiveREST::Base 
    has_rest_method read:   '/applications/:id' 
  end
end