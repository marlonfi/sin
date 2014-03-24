class AddEnteLibreNumberToPagos < ActiveRecord::Migration
  def change
    add_column :pagos, :ente_libre, :string
  end
end
