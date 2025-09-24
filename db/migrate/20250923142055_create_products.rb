class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :sku
      t.string :category
      t.integer :stock_quantity
      t.boolean :is_active

      t.timestamps
    end
  end
end
