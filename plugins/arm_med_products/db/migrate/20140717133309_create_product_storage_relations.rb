class CreateProductStorageRelations < ActiveRecord::Migration
  def change
    create_table :product_storage_relations do |t|
      t.column :product_id, :integer, :null => false
      t.column :product_storage_id, :integer, :null => false
      t.column :count, :integer, :null => false
    end
  end
end
