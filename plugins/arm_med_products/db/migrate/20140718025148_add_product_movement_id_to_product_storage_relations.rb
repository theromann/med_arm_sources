class AddProductMovementIdToProductStorageRelations < ActiveRecord::Migration
  def change
    add_column :product_storage_relations, :product_movement_id, :integer
  end
end
