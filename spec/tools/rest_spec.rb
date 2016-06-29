require_relative '../spec_helper'


describe MercadoPago do
  
   
  context "Rest Client" do
    it "do get request" do
      MercadoPago::RESTClient.get("/dummy_get")
    end
    
    it "do post request" do
      MercadoPago::RESTClient.post("/dummy_post", {data: "hello world"})
    end
    
    it "do put request" do
      MercadoPago::RESTClient.put("/dummy_put", {data: "hello world 2"})
    end
    
    it "do deleted request" do
      MercadoPago::RESTClient.delete("/dummy_delete", {id: "15"})
    end
    
    it "do a request with custom headers" do
      
    end
    
    it "do a failed request" do
    end
    
    it "do a forbidden request" do
    end
    
    it "do a not found request" do 
    end
    
    
    
  end
end