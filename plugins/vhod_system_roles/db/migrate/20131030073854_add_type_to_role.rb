class AddTypeToRole < ActiveRecord::Migration
  def change
    add_column :roles, :type, :string, :default => "Role"
  end
end
