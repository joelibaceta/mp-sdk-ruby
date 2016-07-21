# Create a MercadoPago account
# Install the mercadopago gem

# Require the mercadopago Gem
#
require 'mercadopago'

# Set up your credentials ( https://www.mercadopago.com/mla/account/credentials?type=basic )
#
mercadopago.client_id     = ENV['client_id']
mercadopago.client_secret = ENV['client_secret']

## Refund a Payment
#
payment = MercadoPago::Payment.find(ENV['payment_id'])
payment.status = "refunded"
payment.save

## Create a Partial Refunding
#
MercadoPago::Refund.create({
   collection_id: ENV['payment_id'],
   amount: 10,
   metadata: {
       reason: "some reason",
       external_reference: "some_reference"
   }
})

## Cancel a Payment
#
payment = MercadoPago::Payment.find(ENV['payment_id'])
payment.status = "cancelled"
payment.save