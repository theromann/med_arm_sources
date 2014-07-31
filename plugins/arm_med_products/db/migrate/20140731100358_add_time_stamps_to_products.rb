class AddTimeStampsToProducts < ActiveRecord::Migration
  def change_table
    add_column(:products, :created_at, :datetime)
    add_column(:products, :updated_at, :datetime)
  end
end
