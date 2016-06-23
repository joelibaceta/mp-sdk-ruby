require_relative '../rspec_helper'

describe MercadoPago do

  let (:mpmiddleware){MPMiddleware.new("Dummy Appp")}


  before(:context) do
     # Callback

  end

  context "User" do
    it "Login Callback" do

      mpmiddleware.manage_connect_callback("code", "localhost:3000")

      user_logged = User.last
      expect(user_logged.access_token).to eql("APP_USR-6295877106812064-042916-5ab7e29152843f61b4c218a551227728__LC_LB__-202809963")
      expect(user_logged.public_key).to eql("APP_USR-acc2a2fb-d540-41a2-bf9b-7a40b5644358")
      expect(user_logged.refresh_token).to eql("APP_USR-6295877106812064-042916-5ab7e29152843f61b4c2")
    end
  end
end


