module BitacorasHelper
	def status_bitacora(status)
		if status == 'SOLUCIONADO'
			'<span class="label label-success">SOLUCIONADO</span>'
		else
			'<span class="label label-warning">PENDIENTE</span>'
		end
	end
	def resolver_parametro(parametro)
		path = parametro ? tipo_bitacora_path(parametro, format: 'json') : bitacoras_path(format: 'json') 
		path
	end
end
