class CreateStaffs < ActiveRecord::Migration[8.0]
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :employee_id
      t.string :position
      t.string :department
      t.string :email
      t.string :phone
      t.date :hire_date
      t.decimal :salary
      t.references :store, null: false, foreign_key: true
      t.boolean :is_active

      t.timestamps
    end
  end
end
