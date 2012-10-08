class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :type
      t.string :order_number
      t.integer :created_by
      t.integer :branch_id

      t.boolean :removed, default: false
      t.timestamps
    end
  end
end
