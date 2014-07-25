class CreateProductDepreciations < ActiveRecord::Migration
  def change
    create_table :product_depreciations do |t|
      t.string :name
      t.timestamps
    end
  end
end