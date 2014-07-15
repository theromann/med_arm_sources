class AddProductsGroupIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :products_group_id, :integer
  end
end
