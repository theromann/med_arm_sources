class CreateProductMovements < ActiveRecord::Migration
  def change
    create_table :product_movements do |t|
      t.string :name
    end
  end
end
