#MercadoPago::Customer.load(_user.customer_id)

require_relative '../rspec_helper'

describe MercadoPago do
  context "Customer" do
    it "get a customer" do
      MercadoPago::Customer.load({id: "211713195-rvTmbHpnqmwdKK"})
    end
  end
end