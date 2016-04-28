class AddSaleIdToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :sale_id, :integer
  end
end
