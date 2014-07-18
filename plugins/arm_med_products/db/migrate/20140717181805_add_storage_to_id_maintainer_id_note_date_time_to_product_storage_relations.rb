class AddStorageToIdMaintainerIdNoteDateTimeToProductStorageRelations < ActiveRecord::Migration
  def change
    add_column :product_storage_relations, :product_storage_to_id, :integer
    add_column :product_storage_relations, :maintainer_id, :integer
    add_column :product_storage_relations, :note, :text
    add_column :product_storage_relations, :time, :datetime
  end
end
