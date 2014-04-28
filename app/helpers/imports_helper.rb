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
		when 'ENVIADO'
			'<span class="label label-success">ENVIADO</span>'
		end		
	end
	def month_year(date)
		date ? date.strftime("%b, %Y") : ''
	end
	def date_and_hour(datetime)
		datetime ? datetime.strftime("%d/%m/%Y a las %I:%M%p") : ''
	end	
end
