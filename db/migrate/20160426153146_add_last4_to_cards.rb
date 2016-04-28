class AddLast4ToCards < ActiveRecord::Migration
  def change
    add_column :cards, :last4, :integer
  end
end
