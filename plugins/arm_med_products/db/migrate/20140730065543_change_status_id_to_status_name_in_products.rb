class ChangeStatusIdToStatusNameInProducts < ActiveRecord::Migration
  def up
    rename_column :products, :status_id, :status_name
    change_column :products, :status_name, :string
  end

  def down
    change_column :products, :status_name, :integer
    rename_column :products, :status_name, :status_id
  end
end
