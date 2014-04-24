class AddVoucherToPagos < ActiveRecord::Migration
  def change
  	add_column :pagos, :voucher, :string
  	add_column :pagos, :comentario, :string
  	add_column :pagos, :log, :text
  	
  	add_column :pagos, :created_at, :datetime
    add_column :pagos, :updated_at, :datetime
  end
end
