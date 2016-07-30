describe MercadoPago do
  context "MPMiddleware" do
    let(:app) { ->(env) { [200, env, "app"] } }

    let :middleware do
      MPMiddleware.new(app, required: /^example.com/ )
    end

    it "return a valid value" do
      code, env = middleware.call env_for('https://example.com')

      expect(code).to eql(200)
    end

    it "receive a payment notification" do
      code, env = middleware.call env_for('https://example.com/mp-notifications-middleware?id=00000&topic=payment')
      payment = MercadoPago::Payment.find_by_id("00000")
    end

    it "receive a merchant order notification" do
      code, env = middleware.call env_for('https://example.com/mp-notifications-middleware?id=00001&topic=merchant_order')
      merchant_order = MercadoPago::Payment.find_by_id("00001")
    end
    
    it "receive a oauth callback" do
      code, env = middleware.call env_for('https://example.com/mp-connect-callback?code=TG-5772b5bae4b0cd959900c66e-202809963')
    end

    def env_for url, opts={}
      Rack::MockRequest.env_for(url, opts)
    end

  end
end
