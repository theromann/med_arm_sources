class AddGroupIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :group_id, :integer
  end
end
