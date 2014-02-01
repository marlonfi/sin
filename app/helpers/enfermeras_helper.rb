module EnfermerasHelper
	def sinesss?(flag)
		if flag
			'<span class="badge bg-primary">Agremiado</span>'
		else
			'<span class="badge bg-inverse">No agremiado</span>'
		end
	end
	def afiliado?(flag)
		if flag
			'<span class="label label-primary">Agremiado</span>'
		else
			'<span class="label label-inverse">No agremiado</span>'
		end
	end
end
