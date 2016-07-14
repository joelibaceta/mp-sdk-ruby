describe MercadoPago do
  context "Money Request" do
    it 'make a money request' do
      response = nil
      money_request       = MercadoPago::MoneyRequest.new
      money_request.currency_id   = "ARS"
      money_request.amount        = 20
      money_request.payer_email   = "custom@email.com"
      money_request.description   = "PulpoBot Request"
      money_request.concept_type  = "off_platform"
      money_request.save do |_response|
        response = _response
      end
      
      expect(money_request.class).to eql(MercadoPago::MoneyRequest)
      expect(money_request.response.code).to eql("201") 
      
    end
    
  end
end