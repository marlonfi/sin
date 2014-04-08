module ApplicationHelper
	def full_title(page_title)
		base_title = 'Sistema SINESSS'
		if page_title.empty?
			return base_title
		else
			return "#{page_title} | #{base_title}"	
		end
	end
	def panel_heading(element)
		 element.nombre.to_s == '' ? element.cod_essalud : element.nombre
	end
	def fecha_con_formato(data)
		if data.to_s != ''
			return data.strftime("%d-%m-%Y").to_s
		else  
			return ''
		end
	end
	def meses_espanol
	  %w(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Setiembre Octubre Noviembre Diciembre) 
	end

	def booleano?(bool)
		bool ? 'SI': 'NO'
	end
	def banned?(bool)
		bool ? 'Desabilitado' : 'Habilitado'
	end
	#for devise
	def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
