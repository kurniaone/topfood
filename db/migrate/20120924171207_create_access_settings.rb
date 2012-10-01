class CreateAccessSettings < ActiveRecord::Migration
  def change
    create_table :access_settings do |t|
      t.integer :branch_id
      t.string :order_class
      t.integer :position_id

      t.timestamps
    end
  end
end
