module ImportsHelper
	def print_status(flag)
		case flag
		when 'ESPERA'
			'<span class="label label-primary">ESPERA</span>'
		when 'PROCESANDO'
			'<span class="label label-warning">PROCESANDO</span>'
		when 'ERROR'
			'<span class="label label-danger">ERROR</span>'
		when 'IMPORTADO'
			'<span class="label label-success">IMPORTADO</span>'
		end		
	end
end
