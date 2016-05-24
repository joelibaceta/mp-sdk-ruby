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
        return [200, {}, response]
      else
        return @app.call(env)
      end

    end
  
end