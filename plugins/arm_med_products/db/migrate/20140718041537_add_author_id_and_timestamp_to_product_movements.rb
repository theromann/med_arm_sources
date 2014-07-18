class AddAuthorIdAndTimestampToProductMovements < ActiveRecord::Migration
  def change
    add_column :product_movements, :author_id, :integer
    add_column :product_movements, :created_at, :datetime
    add_column :product_movements, :updated_at, :datetime
  end
end
