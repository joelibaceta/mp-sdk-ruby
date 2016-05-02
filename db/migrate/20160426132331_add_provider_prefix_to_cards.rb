class AddProviderPrefixToCards < ActiveRecord::Migration
  def change
    add_column :cards, :provider_prefix, :string
  end
end
