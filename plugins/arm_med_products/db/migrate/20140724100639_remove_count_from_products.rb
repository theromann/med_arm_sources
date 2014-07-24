class RemoveCountFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :count
  end

  def self.down
    add_column :products, :count, :integer
  end
end
