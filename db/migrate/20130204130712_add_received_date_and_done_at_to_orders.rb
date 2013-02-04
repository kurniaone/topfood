class AddReceivedDateAndDoneAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :received_at, :datetime
    add_column :orders, :done_at,     :datetime
  end
end
