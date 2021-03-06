require_relative '../mercadopago.rb'
require_relative '../../lib/mercadopago/tools/rest_client/rest-client'

class MPMiddleware

  include MercadoPago::RESTClient

  def initialize(app, options= {})
    @app      = app
    @allowed  = options[:allowed]
    @required = options[:required]
    puts "MercadoPago Middleware initialized for #{app}"

  end

  def call(env)
    path, query = env['PATH_INFO'], env['QUERY_STRING']
    params = query.split('&').map{|q| {q.split('=')[0].to_sym => q.split('=')[1]}}.reduce Hash.new, :merge

    if path == '/mp-notifications-middleware'
      notification = MercadoPago::Notification.new(params)
      notification.local_save do |notification|
        begin
          path = "#{File.expand_path(__dir__)}/dumps/#{params[:id]}.notification"
          file = File.open(path, 'wb')
          notification.binary_dump_in_file(file)
          file.close
        rescue
        end
      end

      build_merchant_order(params)         if params[:topic]   ==  'merchant_order'
      build_payment(params)                if params[:topic]   ==  'payment'

      [200, {}, ['Request received successfully']]
    elsif path == '/mp-connect-callback'

      uri       = "#{env['HTTP_HOST']}#{env['PATH_INFO']}" 
      params    = CGI::parse(env["QUERY_STRING"]) 
      user      = manage_connect_callback(params["code"][0], uri)

      env['QUERY_STRING'] = "user_id=#{user.user_id}"
      @app.call(env)
    else
      @app.call(env)
    end

  end


  def manage_connect_callback(authorization_code, redirect_uri)    
    puts "MPConnect Callback received"

    data  = {:grant_type    => 'authorization_code',
             :code          => authorization_code,
             :client_secret => MercadoPago::Settings.ACCESS_TOKEN,
             :redirect_uri  => "https://#{redirect_uri}"}

    res   = post("/oauth/token", json_data: data.to_json).body 
    user  = MercadoPago::User.new(res) 
    user.local_save 
    return user 
  end
  
  def build_merchant_order(params)
    MercadoPago::MerchantOrder.load({id: params[:id]}) do |topic|
      process_request(topic, params)
    end
  end
  
  def build_payment(params)
    MercadoPago::Payment.load({id: params[:id]}) do |topic|
      process_request(topic, params)
    end
  end

  private
  def process_request(topic, params)
      path = "#{File.expand_path(__dir__)}/dumps/#{params[:id]}." + params[:topic]
      file = File.open(path, 'wb')
      topic.binary_dump_in_file(file)
      file.close
  end

end