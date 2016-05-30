require_relative '../mercadopago.rb'



class MPMiddleware


  def initialize(app)
    @app = app
    puts "Mercado Pago Middleware initialized for #{app}"
  end

  def call(env)
    path, query = env['REQUEST_PATH'], env['QUERY_STRING']
    params = query.split('&').map{|q| {q.split('=')[0].to_sym => q.split('=')[1]}}.reduce Hash.new, :merge

    if path == '/mp-notifications-middleware'
      p <<-marquee
            -------------------------- ENV --------------------------'
            #{env}
            ---------------------------------------------------------'
      marquee

      notification = MercadoPago::Notification.new(params)

      notification.local_save do |notification|
        path = "#{File.expand_path(__dir__)}/dumps/#{params[:id]}.notification"

        file = File.open(path, 'wb')
        notification.binary_dump_in_file(file)
        file.close
      end

      if params[:topic] ==  'merchant_order'
        MercadoPago::MerchantOrder.load(params[:id]) do |merchant_order|
          path = "#{File.expand_path(__dir__)}/dumps/#{params[:id]}.merchant_order"
          file = File.open(path, 'wb')
          merchant_order.binary_dump_in_file(file)
          file.close
        end
      end
      if params[:topic] ==  'payment'
        MercadoPago::Payment.load(params[:id]) do |payment|
          path = "#{File.expand_path(__dir__)}/dumps/#{params[:id]}.payment"
          file = File.open(path, 'wb')
          payment.binary_dump_in_file(file)
          file.close
        end
      end


      [200, {}, ['Request received successfully']]
    else
      @app.call(env)
    end

  end

end