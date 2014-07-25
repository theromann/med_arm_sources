class AddIsDepreciationToProductStorageRelations < ActiveRecord::Migration
  def change
    add_column :product_storage_relations, :is_depreciation, :boolean, default: false
  end
end
