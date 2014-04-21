class CreateDonacionEnfermeras < ActiveRecord::Migration
  def change
    create_table :donacion_enfermeras do |t|
      t.decimal :monto, :precision => 8, :scale => 2
      t.date :fecha_entrega
      t.string :motivo
      t.string :generado_por
      t.text :descripcion
      t.integer :enfermera_id

      t.timestamps
    end
  end
end
