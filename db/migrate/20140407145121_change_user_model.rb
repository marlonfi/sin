class ChangeUserModel < ActiveRecord::Migration
  def change
  	change_column :users, :email, :string, :null => true
  	remove_index :users, :email
  	rename_column :users, :habilitado, :desabilitado
  end
end
