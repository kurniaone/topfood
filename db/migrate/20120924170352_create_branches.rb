class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.boolean :center
      t.string :name
      t.string :address
      t.string :phone
      t.string :profile

      t.boolean :removed, default: false
      t.timestamps
    end
  end
end
