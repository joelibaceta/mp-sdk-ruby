require_relative '../spec_helper'


describe MercadoPago do
   
  context "Rest Client" do
    it "do get request" do
      MercadoPago::RESTClient.get("/dummy_get")
    end
    
    it "do post request" do
      MercadoPago::RESTClient.post("/dummy_post", json_data: "hello world")
    end
    
    it "do put request" do
      MercadoPago::RESTClient.put("/dummy_put", json_data: "hello world 2")
    end
    
    it "do deleted request" do
      MercadoPago::RESTClient.delete("/dummy_delete", id: "15")
    end
    
    xit "do a request with custom headers" do
    end
    
    xit "do a failed request" do
    end
    
    xit "do a forbidden request" do
    end
    
    xit "do a not found request" do
    end

    xit "has a request with custom header" do
    end
    
    xit "has a request with json_data" do
    end

    xit "has a request with form data" do
    end

    xit "has a request with extra url params" do
    end

  end
end