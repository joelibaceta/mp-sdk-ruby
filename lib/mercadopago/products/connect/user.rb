module MercadoPago
  class User < ActiveREST::Base

    has_strong_attribute :access_token
    has_strong_attribute :public_key
    has_strong_attribute :refresh_token
    has_strong_attribute :live_mode
    has_strong_attribute :user_id
    has_strong_attribute :token_type
    has_strong_attribute :expires_in
    has_strong_attribute :scope

  end
end
