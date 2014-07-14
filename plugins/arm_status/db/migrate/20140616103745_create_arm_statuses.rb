class CreateArmStatuses < ActiveRecord::Migration
  def change
    create_table :arm_statuses, :force => true do |t|
      t.string :name, :limit => 30, :default => "", :null => false
      t.string :type
      t.boolean :is_final, :default => false, :null => false
      t.boolean :is_default, :default => false, :null => false
      t.integer :issue_statuses, :position, :integer, :default => 1
    end

    add_index :arm_statuses, :position
    add_index :arm_statuses, :is_final
    add_index :arm_statuses, :is_default
  end
end

