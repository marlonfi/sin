class CreateBases < ActiveRecord::Migration
  def change
    create_table :bases do |t|
      t.string :codigo_base
      t.string :nombre_base
      t.timestamps
    end
    add_index :bases, [:codigo_base]
  end
end
