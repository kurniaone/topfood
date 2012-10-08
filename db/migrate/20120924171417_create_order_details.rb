class CreateOrderDetails < ActiveRecord::Migration
  def change
    create_table :order_details do |t|
      t.integer :order_id
      t.text :description
      t.float :quantity
      t.integer :unit_id
      t.date :used_date

      t.boolean :removed, default: false
      t.timestamps
    end
  end
end
