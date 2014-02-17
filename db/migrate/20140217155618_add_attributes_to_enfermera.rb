class AddAttributesToEnfermera < ActiveRecord::Migration
  def change
  	add_column :enfermeras, :sexo, :string
  	add_column :enfermeras, :factor_sanguineo, :string
  	add_column :enfermeras, :fecha_nacimiento, :date
  	add_column :enfermeras, :domicilio_completo, :string
  	add_column :enfermeras, :telefono, :string
  	add_column :enfermeras, :fecha_inscripcion_sinesss, :date
  	add_column :enfermeras, :fecha_ingreso_essalud, :date
  	add_column :enfermeras, :photo, :string
  end
end
