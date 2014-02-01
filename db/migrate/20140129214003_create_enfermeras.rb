class CreateEnfermeras < ActiveRecord::Migration
  def change
    create_table :enfermeras do |t|
      t.integer :ente_id
      t.string :cod_planilla
      t.string :apellido_paterno
      t.string :apellido_materno
      t.string :nombres
      t.string :email
      t.string :regimen
      t.boolean :b_sinesss
      t.boolean :b_fedcut
      t.boolean :b_famesalud
      t.boolean :b_excel
      t.timestamps
    end
    add_index :enfermeras, [:ente_id, :cod_planilla, :b_sinesss]
  end
end
