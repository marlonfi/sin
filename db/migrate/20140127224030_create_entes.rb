class CreateEntes < ActiveRecord::Migration
  def change
    create_table :entes do |t|
      t.integer :red_asistencial_id
      t.integer :base_id
      t.string :cod_essalud
      t.string :nombre
      t.string :contacto_nombre
      t.string :contacto_numero
      t.string :direccion
      t.float :latitud
      t.float :longitud

      t.timestamps
    end
    add_index :entes, [:red_asistencial_id, :base_id, :cod_essalud ]
  end
end
