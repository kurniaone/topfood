class CreateAppsOrders < ActiveRecord::Migration
  def change
    create_table :apps_orders do |t|
      t.string :app_id
      t.integer :order_id
      t.datetime :order_timestamp
      t.datetime :app_timestamp

      t.timestamps
    end
  end
end
