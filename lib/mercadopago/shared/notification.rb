module MercadoPago

  class Notification < ActiveREST::Base

    def self.all # Overwritting all method
      super do |notification_list|
        if notification_list.empty?
          files = Dir["#{File.expand_path(__dir__)}/../dumps/*.notification"]
          files.each do  |file|
            file = File.open(file)
            MercadoPago::Notification.load_from_binary_file(file)
            file.close
          end
        end
      end
    end

  end

end
