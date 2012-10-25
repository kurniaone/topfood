class CreateApprovalRoles < ActiveRecord::Migration
  def change
    create_table :approval_roles do |t|
      t.integer :approval_setting_id
      t.integer :role_id

      t.timestamps
    end
  end
end
