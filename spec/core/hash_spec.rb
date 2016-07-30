describe MercadoPago do
  context "Overwritting Hash methods" do
    it "Hash key act as a method whose return the value for the key" do
      hash = {:"variable1" => 10, :"variable2" => "hello world"}
      expect(hash.variable1).to eql(10)
      expect(hash.variable2).to eql("hello world")
    end

    it "Diff method should return the difference between two hashes" do
      a = {a: "a", b: "b", c: "c"}
      b = {b: "b"}
      expect(a.diff(b)).to eql({b: "b"})
    end
  end
end