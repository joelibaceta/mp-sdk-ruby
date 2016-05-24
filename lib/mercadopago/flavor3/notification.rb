module MercadoPago
  class Notification < ActiveREST::Base
    def all # Overwritting all method
      return `find ../active_rest/ -name 'notification_*'`
    end
  end
end
