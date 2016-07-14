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
      customer = MercadoPago::Customer.create({email: "mail2@demo.com"})
      pp customer
      expect(customer.class).to eql(MercadoPago::Customer)
      customer = MercadoPago::Customer.find_by_email("mail2@demo.com")
      expect(customer.class).to eql(MercadoPago::Customer)
    end
    
    it "update customer" do
      customer = MercadoPago::Customer.find_by_email("mail2@demo.com")
      customer.email = "mail3@email.com"
      customer.update
      customer = MercadoPago::Customer.find_by_email("mail3@demo.com")
      expect(customer.email).to eql("mail3@demo.com")
    end
    
    it "destroy customer" do
      customer = MercadoPago::Customer.find_by_email("mail3@demo.com")
      customer.destroy
      customer = MercadoPago::Customer.find_by_email("mail3@demo.com")
      expect(customer).to eql(nil)   
    end
    
    
    
  end
end