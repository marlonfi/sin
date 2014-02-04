class CreateJunta < ActiveRecord::Migration
  def change
    create_table :junta do |t|
      t.string :base_id
      t.string :secretaria_general
      t.date :inicio_gestion
      t.date :fin_gestion
      t.string :numero_celular
      t.string :email
      t.text :descripcion
      t.string :status

      t.timestamps
    end
    add_index :junta, :base_id
  end
end
