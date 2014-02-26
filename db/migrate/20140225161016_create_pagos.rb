class CreatePagos < ActiveRecord::Migration
  def change
    create_table :pagos do |t|
    	t.integer :enfermera_id
    	t.decimal :monto, :precision => 8, :scale => 2
    	t.date :mes_cotizacion
    	t.string :base
    	t.string :generado_por
        t.string :archivo
    	t.string :status
    end
    add_index :pagos, [:mes_cotizacion, :base]
  end
end
