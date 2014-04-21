class DonacionEnfermera < ActiveRecord::Base
	belongs_to :enfermera
	validates_presence_of :enfermera_id, :motivo, :fecha_entrega, :monto, :generado_por
	validates :descripcion, length: { maximum: 1000 }
	validates :generado_por, length: { maximum: 250 }
	validates :motivo, length: { maximum: 250 }
	validates_date :fecha_entrega
	validates_numericality_of :monto, greater_than: 0.00
end
