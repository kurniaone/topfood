class CreateApprovalManagements < ActiveRecord::Migration
  def change
    create_table :approval_managements do |t|
      t.integer :approval_setting_id
      t.integer :management_id

      t.boolean :removed, default: false
      t.timestamps
    end
  end
end
