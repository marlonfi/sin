class CreateDonacionBases < ActiveRecord::Migration
  def change
    create_table :donacion_bases do |t|
      t.string :product_name
      t.string :category
      t.date :release_date
      t.text :descripcion
      t.string :generado_por
      t.integer :base_id

      t.timestamps
    end
  end
end
