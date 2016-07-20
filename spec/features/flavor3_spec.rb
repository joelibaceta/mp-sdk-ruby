require_relative '../spec_helper'
require_relative '../../lib/mercadopago'
require 'pp'
require 'colorize'

describe MercadoPago do
  context "Create a preference" do
    
    before do
      @items            = (0..3).map{|i| build(:valid_item)}
      @additional_item  = build(:valid_item)
      @payer            = build(:valid_payer_with_minimal_data) 
    end
	
    it "with minimal valid data" do
 
			preference = MercadoPago::Preference.new({
			  items: @items,
        payer: @payer
			})
      
      preference.save  
      expect(preference.id).to eql("202809963-a2901d2b-b2e0-4479-ac4c-97950c09b2e4") 
      
    end
    
    it 'should allow to update a preference' do
      
      response = nil
      preference = MercadoPago::Preference.find_by_id("202809963-a2901d2b-b2e0-4479-ac4c-97950c09b2e4")
      
      preference.items << @additional_item 
      preference.save {|_response| response = _response }
      
      expect(response.code).to eql("200")
      expect(preference.items.count).to eql(4)
      
    end

    it "should receive a merchant order notification" do
      
    end
    

  end

  context "A payment was made" do
    it "should receive a payment notification" do
      
    end
  end
end
