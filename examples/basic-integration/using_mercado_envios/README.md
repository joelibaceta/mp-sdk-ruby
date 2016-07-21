### Receive Payment

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

**Create a Preference**

```ruby
preference = MercadoPago::Preference.new
```

**Create and Item**

```ruby
item              = MercadoPago::Item.new
item.id           = 'item-ID-1234'
item.title        = 'Incredible Silk Pants'
item.description  = 'Sit quasi nulla reiciendis officia sunt cupiditate.'
item.category_id  = 'Fashion'
item.picture_url  = 'https://robohash.org/quiaadipisciculpa.png?size=300x300&set=set1'
item.currency_id  = 'ARS'
item.quantity     = 1
item.unit_price   = 390

shipment          = MercadoPago::Shipment.new
```

**The available values are:**

 | 
------------ | -------------
custom         |   Custom shipping
me2            |   MercadoEnvíos
not_specified  |   Shipping mode not specified

```ruby
shipment.mode         = 'me2'
```

```ruby
shipment.dimensions   = '30x30x30,500'
shipment.local_pickup = true
```

**The available values are:**

 | 
------------ | -------------
OCA Estándar    | 73328
OCA Prioritario | 73330

```ruby
shipment.free_methods             = [{id: 73328}]
shipment.default_shipping_method  = 73328

shipment.receiver_address = {
  zip_code: "5700",
  street_name: "Wallabe Way", 
  street_number: 42
}
```

**Add the Item to the preference Items array and Set the Shipment Preferences**

```ruby
preference.items    = [item]
preference.shipment = shipment
```

**Save the preference**

Save the preference to send a POST request to the endpoint and update the preference object with the preference resource attrbutes created

```ruby
preference.save
```

**Use the init_point attribute to build a payment button**

```html
<a href="<%= preference.init_point %>" mp-mode="blank"> Pay </a>
```

**Opening Modes**

 | 
------------ | -------------
modal window | popup 
pop-up       | window
blank        | new window or tab
redirect     | same window

