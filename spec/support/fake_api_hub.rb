require 'sinatra/base'

class FakeAPIHub < Sinatra::Base

  post '/oauth/token' do
    json_response 200, 'mp_connect.json'
  end

  get '/v1/payment_methods' do
    json_response 200, 'payment_methods.json'
  end

  post '/v1/payment_method' do
    #json_response 200, 'payment_methods.json'
  end

  post '/v1/create' do
    #json_response 200, 'payment_methods.json'
  end
  
  get '/v1/identification_types' do
    json_response 200, 'identification_types.json'
  end

  post '/checkout/preferences' do
    json_response 200, 'preference_post.json'
  end
  
  get '/v1/customers/211713195-rvTmbHpnqmwdKK' do
    json_response 200, 'customer_211713195-rvTmbHpnqmwdKK.json'
  end
  
  put '/v1/customers/211713195-rvTmbHpnqmwdKK' do
    json_response 200, 'customer_211713195-rvTmbHpnqmwdKK_updated.json'
  end

  get '/collections/notifications/00000' do
    json_response 200, 'notification_00000.json'
  end

  get '/merchant_orders/00001' do
    json_response 200, 'merchant_order_00001.json'
  end
  
  post '/v1/customers/' do
    json_response 200, 'new_customer.json'
  end
  
  post '/money_requests' do
    json_response 200, 'money_request.json'
  end
  
  post '/dummy_post' do
  end
  
  get '/dummy_get' do
  end
  
  put '/dummy_put' do 
  end
  
  delete '/dummy_delete' do 
  end
  

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code

    File.open(File.dirname(__FILE__) + '/../fixtures/' + file_name, 'rb').read
  end


end

