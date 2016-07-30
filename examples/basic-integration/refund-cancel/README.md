# Refund or Cancel a Payment


Create a MercadoPago account 
Install the mercadopago gem 

**Require the mercadopago Gem**

```ruby
require 'mercadopago'
```

**Set up your credentials ( https://www.mercadopago.com/mla/account/credentials?type=basic )**

```ruby
mercadopago.client_id     = ENV['client_id']
mercadopago.client_secret = ENV['client_secret']
```

#### Refund a Payment

```ruby
payment = MercadoPago::Payment.find(ENV['payment_id'])
payment.status = "refunded"
payment.save
```

#### Create a Partial Refunding

```ruby
MercadoPago::Refund.create({
   collection_id: ENV['payment_id'],
   amount: 10,
   metadata: {
       reason: "some reason",
       external_reference: "some_reference"
   }
})
```

#### Cancel a Payment

```ruby
payment = MercadoPago::Payment.find(ENV['payment_id'])
payment.status = "cancelled"
payment.save
```