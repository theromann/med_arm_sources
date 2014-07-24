class CreateStorageProductCount < ActiveRecord::Migration
  def change
    create_table :storage_product_counts do |t|
      t.integer :product_id
      t.integer :storage_id
      t.integer :count, :default => 0
    end
  end
end
