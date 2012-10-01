class CreateApprovalSettings < ActiveRecord::Migration
  def change
    create_table :approval_settings do |t|
      t.integer :branch_id
      t.string :order_class
      t.integer :position_id

      t.timestamps
    end
  end
end
