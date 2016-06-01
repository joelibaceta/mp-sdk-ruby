require_relative '../rspec_helper'
require_relative '../../lib/mercadopago'
require 'pp'
require 'colorize'

describe MercadoPago do
  context "Create a preference " do

    before do
      @items = (0..3).map{|i| build(:valid_item)}
      @payer = build(:valid_payer_with_minimal_data)
      #TODO: Shipping
    end
	
    it "with valid data" do
 
			preference = MercadoPago::Preference.new

      preference.items = @items
      preference.payer = @payer

      preference.save
      
      expect(preference.id).to eql("202809963-a2901d2b-b2e0-4479-ac4c-97950c09b2e4")

      notification = MercadoPago::Notification.last

			expect(notification.id).to eql("313983329")

    end

    it "should receive a merchant order notification" do

    end


  end

  context "A payment was made" do
    it "should receive a payment notification" do

    end
  end
end
