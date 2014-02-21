class Bitacora < ActiveRecord::Base
	belongs_to :enfermera
	belongs_to :import
	validates_presence_of :enfermera_id
	validates_inclusion_of :tipo, :in => ['AFILIACION', 'DESAFILIACION', 'TRASLADO', 'OTROS']
	validates_inclusion_of :status, :in => ['PENDIENTE', 'SOLUCIONADO']
	validates :ente_inicio, length: { maximum: 250 }
	validates :ente_fin, length: { maximum: 250 }
	validates :descripcion, length: { maximum: 250 }
	scope :pendientes, -> { where(status: 'PENDIENTE') }

	def change_status
		if self.status == 'PENDIENTE'
			self.status = 'SOLUCIONADO'	
		else
			self.status = 'PENDIENTE'
		end			
	end
end
