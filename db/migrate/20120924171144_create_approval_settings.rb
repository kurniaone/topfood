class CreateApprovalSettings < ActiveRecord::Migration
  def change
    create_table :approval_settings do |t|
      t.string :order_class

      t.boolean :removed, default: false
      t.timestamps
    end
  end
end
