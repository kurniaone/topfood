class CreateAccessSettings < ActiveRecord::Migration
  def change
    create_table :access_settings do |t|
      t.string :order_class
      t.integer :position_id

      t.boolean :removed, default: false
      t.timestamps
    end
  end
end
