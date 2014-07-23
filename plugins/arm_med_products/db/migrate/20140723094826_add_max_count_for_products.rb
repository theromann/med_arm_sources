class AddMaxCountForProducts < ActiveRecord::Migration
  def change
    add_column :products, :max_count, :integer
  end
end
