class CreateUserBranches < ActiveRecord::Migration
  def change
    create_table :user_branches do |t|
      t.integer :user_id
      t.integer :role_id
      t.integer :branch_id

      t.timestamps
    end

    # add_index :user_branches, [:user_id, :role_id, :branch_id], :unique => true
  end
end
