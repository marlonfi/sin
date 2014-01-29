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
end
