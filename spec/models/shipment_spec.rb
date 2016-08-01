require_relative '../spec_helper'

describe MercadoPago do
  context "Shipment" do
    
    it 'create a shipment like an object' do
      shipment = MercadoPago::Shipment.new
      shipment
    end

    it 'create a shipment from hash' do
      shipment = MercadoPago::Shipment.new({
        mode: "me2",
        dimensions: "30x30x30,500",
        local_pickup: true,
        
      })
      expect(shipment.class).to eql(MercadoPago::Shipment)
    end
    
    it 'update a shipment' do
      
    end
    
    
  end
end