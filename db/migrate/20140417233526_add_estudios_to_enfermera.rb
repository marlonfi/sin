class AddEstudiosToEnfermera < ActiveRecord::Migration
  def change
  	add_column :enfermeras, :especialidad, :string
  	add_column :enfermeras, :maestria, :string
  	add_column :enfermeras, :doctorado, :string
  end
end
