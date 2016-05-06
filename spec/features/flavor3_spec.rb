require_relative '../rspec_helper'
require_relative '../../lib/mercadopago'

describe MercadoPagoBlack do
  context "Create a preference_spec.rb" do
    it "with valid_and_full data" do
      preference = build(:preference_with_valid_data)
      items = (0..3).map{|i| build(:valid_item)}
      preference.items = items
    end
  end
end