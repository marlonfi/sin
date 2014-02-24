class AddTipoTextToImports < ActiveRecord::Migration
  def change
  	add_column :imports, :tipo_txt, :string
  end
end
