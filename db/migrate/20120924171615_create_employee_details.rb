class CreateEmployeeDetails < ActiveRecord::Migration
  def change
    create_table :employee_details do |t|
      t.integer :order_id
      t.integer :position_id
      t.integer :department_id
      t.text :description
      t.integer :quantity
      t.string :gender
      t.date :used_date

      t.boolean :removed, default: false
      t.timestamps
    end
  end
end
