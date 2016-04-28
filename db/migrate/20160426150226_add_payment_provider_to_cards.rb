class AddPaymentProviderToCards < ActiveRecord::Migration
  def change
    add_column :cards, :payment_provider, :string
  end
end
