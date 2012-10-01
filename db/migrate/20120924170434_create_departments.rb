class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.integer :branch_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
