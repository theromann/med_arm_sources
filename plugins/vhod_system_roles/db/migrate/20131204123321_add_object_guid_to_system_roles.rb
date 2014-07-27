class AddObjectGuidToSystemRoles < ActiveRecord::Migration
  def change
    add_column :roles, :object_guid, :string
  end
end
