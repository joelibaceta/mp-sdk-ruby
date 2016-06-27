require_relative '../mercadopago.rb'
require_relative '../../lib/mercadopago/tools/rest_client/rest-client'

class MPMiddleware

  include MercadoPago::RESTClient

  def initialize(app)
    @app = app
    puts "MercadoPago Middleware initialized for #{app}"
  end

  def call(env)
    path, query = env['PATH_INFO'], env['QUERY_STRING']
    params = query.split('&').map{|q| {q.split('=')[0].to_sym => q.split('=')[1]}}.reduce Hash.new, :merge

    if path == '/mp-notifications-middleware'
      notification = MercadoPago::Notification.new(params)
      notification.local_save do |notification|
        path = "#{File.expand_path(__dir__)}/dumps/#{params[:id]}.notification"
        file = File.open(path, 'wb')
        notification.binary_dump_in_file(file)
        file.close
      end

      build_payment(params)         if params[:topic]   ==  'merchant_order'
      build_merchant_order(params)  if params[:topic]   ==  'payment'

      [200, {}, ['Request received successfully']]
    elsif path == '/mp-connect-callback'
      uri  = "#{env['HTTP_HOST']}#{env['PATH_INFO']}"
      params = env["rack.request.query_hash"]
      manage_connect_callback(params["authorization_code"], uri)
    else
      @app.call(env)
    end

  end

  def manage_connect_callback(authorization_code, redirect_uri)

    data  = {:grant_type    => 'authorization_code',
             :code          => authorization_code,
             :client_secret => MercadoPago::Settings.ACCESS_TOKEN,
             :redirect_uri  => redirect_uri}

    res   = post("/oauth/token", data)
    user  = MercadoPago::User.new(res)

    user.local_save
  end

  def build_payment(params)
    MercadoPago::MerchantOrder.load(params[:id]) do |merchant_order|
      path = "#{File.expand_path(__dir__)}/dumps/#{params[:id]}.merchant_order"
      file = File.open(path, 'wb')
      merchant_order.binary_dump_in_file(file)
      file.close
    end
  end

  def build_merchant_order(params)
    MercadoPago::Payment.load(params[:id]) do |payment|
      path = "#{File.expand_path(__dir__)}/dumps/#{params[:id]}.payment"
      file = File.open(path, 'wb')
      payment.binary_dump_in_file(file)
      file.close
    end
  end

end