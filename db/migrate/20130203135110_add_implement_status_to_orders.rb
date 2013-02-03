class AddImplementStatusToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :implement_status, :string
  end
end
