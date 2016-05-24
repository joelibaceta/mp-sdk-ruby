module MercadoPago
  class Notification < ActiveREST::Base
    def self.all # Overwritting all method
      return `pwd` #`find ../active_rest/ -name 'notification_*'`
    end
  end
end
