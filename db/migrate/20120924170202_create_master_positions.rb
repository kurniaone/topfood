class CreateMasterPositions < ActiveRecord::Migration
  def change
    create_table :master_positions do |t|
      t.string :code
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
