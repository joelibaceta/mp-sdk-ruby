#MercadoPago::Customer.load(_user.customer_id)

require_relative '../spec_helper'

describe MercadoPago do
  context "Customer" do
    
    it "get a customer" do
      customer = MercadoPago::Customer.load({id: "211713195-rvTmbHpnqmwdKK"})
      expect(customer.class).to eql(MercadoPago::Customer)
    end
    
    it "find a customer" do
      customer = MercadoPago::Customer.find("211713195-rvTmbHpnqmwdKK")
      expect(customer.id).to eql("211713195-rvTmbHpnqmwdKK")
    end
    
    it "find by email" do
      customer = MercadoPago::Customer.find_by_email("mail@demo.com")
      expect(customer.email).to eql("mail@demo.com")
    end
    
    it "getting cards from customer" do
      customer = MercadoPago::Customer.find("211713195-rvTmbHpnqmwdKK")
      card = customer.cards.last 
      expect(card.class).to eql(MercadoPago::Card)
    end
    
    it "creating a customer" do
      customer = MercadoPago::Customer.create({email: "demo2@email.com"})
      expect(customer.class).to eql(MercadoPago::Customer)  
    end
    
  end
end