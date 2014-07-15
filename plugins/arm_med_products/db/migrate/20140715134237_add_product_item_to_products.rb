class AddProductItemToProducts < ActiveRecord::Migration
  def change
    add_column :products, :product_item, :string
  end
end
