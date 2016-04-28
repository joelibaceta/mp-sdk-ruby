class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :card_token
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
