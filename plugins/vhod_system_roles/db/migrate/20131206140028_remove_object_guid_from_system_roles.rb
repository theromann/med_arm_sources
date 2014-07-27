class RemoveObjectGuidFromSystemRoles < ActiveRecord::Migration
  def up
    remove_column :roles, :object_guid
  end

  def down
    add_column :roles, :object_guid, :string
  end
end
