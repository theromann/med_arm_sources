class CreateStorageProductCount < ActiveRecord::Migration
  def change
    create_table :storage_product_count do |t|
      t.integer :product_id
      t.integer :storage_id
      t.integer :count
    end
  end
end
