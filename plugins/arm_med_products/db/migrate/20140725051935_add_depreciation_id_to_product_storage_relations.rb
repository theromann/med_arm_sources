class AddDepreciationIdToProductStorageRelations < ActiveRecord::Migration
  def change
    add_column :product_storage_relations, :product_depreciation_id, :integer
  end
end
