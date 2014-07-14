class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :count
      t.integer :price
      t.integer :location_id
      t.string :note
      t.string :unit
      t.integer :status_id
    end
  end
end
