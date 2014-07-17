class CreateProductStorages < ActiveRecord::Migration
  def change
    create_table :product_storages do |t|
      t.string :name
      t.integer :type_id
    end
  end
end
