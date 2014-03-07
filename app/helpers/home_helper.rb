module HomeHelper
	def chart_flujo_mensual(data)
		data_for_js = []
		data.each do |k,v|
			cas = v[0] == 0.to_f ? nil : v[0]
			cn = v[1] == 0.to_f ? nil : v[1]
			data_for_js << {month: k, cas: cas, cn: cn}
		end
		data_for_js.reverse
	end
	def chart_enfermeras_anual(data)
		data_for_js = []
		data.each do |k,v|
			data_for_js << {month: k, enfermeras: v}
		end
		return data_for_js
	end
end
