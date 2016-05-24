class MPMiddleware
  def initialize(app)
    @app = app
    puts "Mercado Pago Middleware initialized for #{app}" 
  end
  
  def call(env) 
      
      path = env["REQUEST_PATH"]

      response = ["<html><body><p> Request received successfully</p></body></html>"]

      if path == '/mp-notifications-middleware'
        p "-------------------------- ENv --------------------------"
        p env
        p "---------------------------------------------------------"
        
        params = env["QUERY_STRING"].split("&").map{|q| {q.split("=")[0].to_sym => q.split("=")[1]}}.reduce Hash.new, :merge
        
        case params[:topic]
          when "merchant_order"
            MercadoPago::MerchantOrder.load(params[:id])
          when "payment"
            MercadoPago::Payment.load(params[:id])
        end
        
        return [200, {}, response]
      else
        return @app.call(env)
      end

    end
  
end