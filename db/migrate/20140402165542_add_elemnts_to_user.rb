class AddElemntsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :dni, :string
  	add_column :users, :apellidos_nombres, :string
  	add_column :users, :cargo, :string
  	add_column :users, :superadmin, :boolean
  	add_column :users, :admin, :boolean
  	add_column :users, :organizacional, :boolean
  	add_column :users, :informatica, :boolean
  	add_column :users, :reader, :boolean
  	add_column :users, :habilitado, :boolean
  end
end
