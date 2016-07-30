require_relative '../spec_helper'

describe MercadoPago do

  let (:mpmiddleware){MPMiddleware.new("Dummy Appp")}
  let (:user_logged) { MercadoPago::User.last }
  
  fake_accces_token = "APP_USR-6295877106812064-042916-5ab7e29152843f61b4c218a551227728__LC_LB__-202809963"
  fake_auth_code         = "TG-577d5185e4b05f92a20362c1-202809963"
  
  context "User" do
    
    it "Login Callback" do
      
      # Simulate an oauth callback
      #  
      mpmiddleware.manage_connect_callback(fake_auth_code, "localhost:3000")
      user_logged = MercadoPago::User.last
      
      expect(user_logged.access_token).to   eql(fake_accces_token)
      expect(user_logged.public_key).to     eql("APP_USR-acc2a2fb-d540-41a2-bf9b-7a40b5644358")
      expect(user_logged.refresh_token).to  eql("APP_USR-6295877106812064-042916-5ab7e29152843f61b4c2")
    end
    
    it "Refresh user credentials" do
      user_logged = MercadoPago::User.last
      
      user_logged.refresh_credentials
      expect(user_logged.access_token).to eql(fake_accces_token)
    end
    
  end
  
end


