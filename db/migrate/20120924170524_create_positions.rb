class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :branch_id
      t.integer :department_id
      t.string :name
      t.text :description
      t.integer :level
      t.integer :parent_id

      t.timestamps
    end
  end
end
