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

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code

    File.open(File.dirname(__FILE__) + '/../fixtures/' + file_name, 'rb').read
  end


end

