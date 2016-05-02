class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :cart_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
