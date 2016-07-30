module MercadoPago

  class Notification < ActiveREST::Base
    
    has_strong_attribute :id,                 primary_key: true
    
    @proc_on_payment        = nil
    @proc_on_merchant_order = nil

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
    
    # def local_save(&block)
  #     super(block)
  #   end
    
    # def self.on_payment(&block)
#       @proc_on_payment == block
#     end
#
#     def self.on_merchant_order(&block)
#       @proc_on_merchant_order == block
#     end

  end

end
