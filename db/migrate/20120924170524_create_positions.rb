class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :code
      t.string :name
      t.text :description
      t.float :level
      t.integer :parent_id

      t.boolean :removed, default: false
      t.timestamps
    end
  end
end
