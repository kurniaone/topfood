class CreateMasterDepartments < ActiveRecord::Migration
  def change
    create_table :master_departments do |t|
      t.string :code
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
