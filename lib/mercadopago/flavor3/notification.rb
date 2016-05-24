module MercadoPago
  class Notification < ActiveREST::Base
    def self.all # Overwritting all method
      return `find . -name 'notification_*'`
    end
  end
end
