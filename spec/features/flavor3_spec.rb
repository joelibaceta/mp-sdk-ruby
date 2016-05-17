require_relative '../rspec_helper'
require_relative '../../lib/mercadopago'
require 'pp'
require 'colorize'

describe MercadoPago do
  context "Create a preference " do
	
    xit "with valid_and_full data" do


      #preference = build(:preference_with_valid_data)
			preference = MercadoPago::Preference.new

      item1 = MercadoPago::Item.new  # (0..3).map{|i| build(:valid_item)}

			item1.unit_price = "5.0"
			item1.id = "item-ID-1234"
			item1.description = "A random item"
			item1.quantity = "1"
			item1.currency_id = "ARS"

			item2 = MercadoPago::Item.new ({id: "item-ID-4321", 
																			description: "Another random item", 
																			quantity: 5, 
																			"currency_id": "ARS"})
			
      preference.items = [item1, item2]

      preference.save
			puts "\nPREFERENCIA CREADA:".light_green
			puts "==============================\n\n".green
      pp preference
			puts "\nPREFERENCIA EN FORMATO JSON".light_green
			puts "=============================\n\n".green
			puts preference.to_json.light_white
			puts "\nITEMS DE PREFERENCIA".light_green
			puts "============================\n\n".green
			pp preference.items
			puts "\nITEMS EN FORMATO JSON".light_green
			puts "============================\n\n".green
			puts preference.items.to_json.light_white
			puts "\n"	

    end
  end
end
