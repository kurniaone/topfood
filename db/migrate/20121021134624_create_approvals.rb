class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.integer  :order_id
      t.integer  :user_id
      t.string   :user_name
      t.integer  :role_id
      t.string   :role_name
      t.boolean  :approved
      t.datetime :do_at

      t.timestamps
    end
  end
end
