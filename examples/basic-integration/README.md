### Receive Payment

Create a MercadoPago account 
Install the mercadopago gem 

Require the mercadopago Gem

```ruby
require 'mercadopago'
```

Set up your credentials ( https://www.mercadopago.com/mla/account/credentials?type=basic )

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
item.id           = "item-ID-1234"
item.title        = "Incredible Silk Pants"
item.description  = "Sit quasi nulla reiciendis officia sunt cupiditate."
item.category_id  = "Fashion"
item.picture_url  = "https://robohash.org/quiaadipisciculpa.png?size=300x300&set=set1"
item.currency_id  = "ARS"
item.quantity     = 1
item.unit_price   = 390
```

**Add the Item to the preference Items array**

```ruby
preference.items  = [item]
```

**Save the preference**

Save the preference to send a POST request to the endpoint 
and update the preference object 
with the preference resource attrbutes created
 
```ruby
preference.save
```


**Use the init_point attribute to build a payment button**

```haml
<a href="<%= preference.init_point %>" mp-mode="blank"> Pay </a>
```

**Opening Modes**

Mode|Result
------------ | -------------
modal window:| popup 
pop-up:      | window
blank:       | new window or tab
redirect:    | same window

