module BasesHelper
	def mostrar_base(ente)
		ente.base ? ente.base.codigo_base : 'Sin Base'
	end
end
