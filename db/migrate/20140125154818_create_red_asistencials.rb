class CreateRedAsistencials < ActiveRecord::Migration
  def change
    create_table :red_asistencials do |t|
      t.string :cod_essalud
      t.string :nombre
      t.string :contacto_nombre
      t.string :contacto_telefono

      t.timestamps
    end
     add_index :red_asistencials, :cod_essalud
  end
end
