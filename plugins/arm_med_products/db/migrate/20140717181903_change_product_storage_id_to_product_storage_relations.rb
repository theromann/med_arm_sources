class ChangeProductStorageIdToProductStorageRelations < ActiveRecord::Migration
  def up
    rename_column(:product_storage_relations, :product_storage_id, :product_storage_from_id)
  end

  def down
    rename_column(:product_storage_relations, :product_storage_from_id, :product_storage_id)
  end
end
