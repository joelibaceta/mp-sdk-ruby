module MercadoPagoBlack
  class Preference < ActiveREST::Base


    has_crud_rest_methods(create: '/checkout/preferences',
                          read:   '/checkout/preferences/:id',
                          update: '/checkout/preferences/:id')

    def save
      response = super
      # add attributes after save
      self.id  = response["id"] # Save the preference ID Locally
    end

  end
end