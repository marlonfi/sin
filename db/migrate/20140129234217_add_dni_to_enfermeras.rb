class AddDniToEnfermeras < ActiveRecord::Migration
  def change
  	add_column :enfermeras, :dni, :string
  end
end
