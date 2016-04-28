class AddFirst6ToCards < ActiveRecord::Migration
  def change
    add_column :cards, :first6, :integer
  end
end
