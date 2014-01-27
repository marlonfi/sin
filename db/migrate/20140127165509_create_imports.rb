class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :tipo_clase
      t.date :fecha_pago
      t.string :responsable
      t.string :archivo
      t.string :descripcion
      t.string :formato_org

      t.timestamps
    end
    add_index :imports, [:tipo_clase, :fecha_pago, :created_at]
  end
end
