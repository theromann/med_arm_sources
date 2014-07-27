class CreateGroupsSystemRoles < ActiveRecord::Migration
  def change
    create_table :groups_system_roles do |t|
      t.column :group_id, :integer
      t.column :system_role_id, :integer
    end
  end
end
