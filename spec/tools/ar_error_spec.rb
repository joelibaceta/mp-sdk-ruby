describe MercadoPago do
  context "ARError" do
    it "raise ar error" do
      expect { raise ARError.new("An Error") }.to raise_error(ARError, "An Error")
    end
  end

end
