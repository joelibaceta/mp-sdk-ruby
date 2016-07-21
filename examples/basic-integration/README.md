### Receive Payment

Create a MercadoPago account 
Install the mercadopago gem 

Require the mercadopago Gem

`require 'mercadopago'`

Set up your credentials ( https://www.mercadopago.com/mla/account/credentials?type=basic )

* `mercadopago.client_id     = ENV['client_id']`
* `mercadopago.client_secret = ENV['client_secret']`

Create a Preference 
`preference = MercadoPago::Preference.new`

Create and Item

```
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

Add the Item to the preference Items array

`preference.items  = [item]`

Save the preference to send a POST request to the endpoint 
and update the preference object 
with the preference resource attrbutes created
 
`preference.save`


Use the init_point attribute to build a payment button 

```
<a href="<%= preference.init_point %>" mp-mode="blank"> Pay </a>
```

Opening Modes | Description
------------ | -------------
modal window:| popup 
pop-up:      | window
blank:       | new window or tab
redirect:    | same window

