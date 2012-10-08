class CreateManagements < ActiveRecord::Migration
  def change
    create_table :managements do |t|
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
