class AddFullNameToEnfermeras < ActiveRecord::Migration
  def change
    add_column :enfermeras, :full_name, :string
    add_index :enfermeras, :full_name
  end
end
