class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.text :address
      t.string :phone
      t.string :email
      t.string :manager_name
      t.string :opening_hours
      t.boolean :is_active
      t.text :description

      t.timestamps
    end
  end
end
