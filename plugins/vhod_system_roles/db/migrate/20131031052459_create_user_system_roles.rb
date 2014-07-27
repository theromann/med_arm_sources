class CreateUserSystemRoles < ActiveRecord::Migration
  def up
    create_table :user_system_roles do |t|
      t.column :user_id, :integer
      t.column :system_role_id, :integer
    end
  end

  def down
    drop_table :user_system_roles
  end
end
