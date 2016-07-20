describe MercadoPago do
  context "Strong Variable" do
    
    let (:dummy_variable) { 
      StrongVariable.new({ 
         name:      "dummy",
         type:      String,
         length:    20,
         read_only: false
       })
    }

    let (:read_only_variable) { 
      StrongVariable.new({
        name:       "read_only",
        type:       String,
        read_only:  true
      })
    }

    it "Read parameters supported" do
      expect(dummy_variable.name).to      eql("dummy")
      expect(dummy_variable.type).to      eql(String)
      expect(dummy_variable.length).to    eql(20)
      expect(dummy_variable.read_only).to eql(false)
    end

    it "Try to put a wrong value" do
      expect(dummy_variable.allow_this?(100)).to eql(false)
    end

    it "should return a hash with the parameters" do
      expect(dummy_variable.to_hash).to eql({
         name:      "dummy",
         type:      String,
         length:    20,
         read_only: false
        })
    end
    
  end
end
