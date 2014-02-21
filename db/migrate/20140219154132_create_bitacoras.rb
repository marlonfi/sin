class CreateBitacoras < ActiveRecord::Migration
  def change
    create_table :bitacoras do |t|
      t.integer :enfermera_id
      t.string :tipo
      t.integer :import_id
      t.string :status
      t.string :ente_inicio
      t.string :ente_fin
      t.string :descripcion
      t.timestamps
    end
    add_index :bitacoras, [:enfermera_id, :tipo, :status]
  end
end
