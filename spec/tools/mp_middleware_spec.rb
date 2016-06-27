describe MercadoPago do
  context "MPMiddleware" do
    let(:app) { ->(env) { [200, env, "app"] } }

    let :middleware do
      MPMiddleware.new(app, required: /^example.com/ )
    end

    it "return a valid value" do
      code, env = middleware.call env_for('http://example.com')

      expect(code).to eql(200)
    end

    it "receive a payment notification" do
      code, env = middleware.call env_for('http://example.com/mp-notifications-middleware?id=00000&topic=payment')
      payment = MercadoPago::Payment.find_by_id("00000")
    end

    it "receive a merchant order notification" do
      code, env = middleware.call env_for('http://example.com/mp-notifications-middleware?id=00001&topic=merchant_order')
      merchant_order = MercadoPago::Payment.find_by_id("00001")
    end

    def env_for url, opts={}
      Rack::MockRequest.env_for(url, opts)
    end

  end
end
