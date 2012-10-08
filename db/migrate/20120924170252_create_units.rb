class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :code
      t.string :name

      t.boolean :removed, default: false
      t.timestamps
    end
  end
end
