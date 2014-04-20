class DonacionesBasesPdf < Prawn::Document
	delegate :fecha_con_formato,  to: :@view
	def initialize(donaciones, fecha_inicio, fecha_fin, view)
		super()
		@donaciones = donaciones
		@fecha_fin = Date.parse fecha_fin
		@fecha_inicio = Date.parse fecha_inicio
		@view = view
		@address_x = 35
		@lineheight_y = 12
		@font_size = 9
		@invoice_header_x = 325
		unchangable_header
		data_header
		all_data
	end

	def unchangable_header
		logopath = "#{Rails.root}/app/assets/images/logo.jpg"
	  initial_y = cursor
	  initialmove_y = 5
	  font_size = 9

	  move_down initialmove_y

	  # Add the font style and size
	  font "Helvetica"
	  font_size @font_size

	  #start with EON Media Group
	  text_box "SINESSS", :at => [@address_x, cursor]
	  move_down @lineheight_y
	  text_box "Sindicato Nacional De Enfermeras Del Seguro Social De Salud", :at => [@address_x, cursor]
	  move_down @lineheight_y
	  text_box "Manuel Arrisueño 635", :at => [@address_x, cursor]
	  move_down @lineheight_y
	  text_box "Urb. Santa Catalina / La Victoria / Lima", :at => [@address_x, cursor]
	  move_down @lineheight_y

	  last_measured_y = cursor
	  move_cursor_to bounds.height

	  image logopath, :width => 100, :position => :right

	  move_cursor_to last_measured_y

	end
	def data_header
		# client address
	  move_down 65
	  last_measured_y = cursor

	  text_box "Donaciones a Bases en el perido #{fecha_con_formato(@fecha_inicio)} a #{fecha_con_formato(@fecha_fin)}", :at => [@address_x, cursor]
	  move_down @lineheight_y
	  text_box "Total: #{@donaciones.count} donaciones", :at => [@address_x, cursor]
	  move_down @lineheight_y
		move_cursor_to last_measured_y

	  
	end

	def all_data
  	
	  move_down 45
	  all_donaciones = []
	  @donaciones.each do |donacion|
	  	all_donaciones << [donacion.base.codigo_base, donacion.product_name,
	  								 fecha_con_formato(donacion.release_date), donacion.generado_por]
	  end
	  #debugger
	  invoice_services_data = 
	    [["Cod. Base", "Producto donado", "Fecha entrega", "Registrado por"]] +
	    all_donaciones +
	    [[" ", " ", " ", " "]]
	  

	  table(invoice_services_data, :width => bounds.width) do
	    style(row(1..-1).columns(0..-1), :padding => [4, 5, 4, 5], :borders => [:bottom], :border_color => 'dddddd')
	    style(row(0), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
	    style(row(0).columns(0..-1), :borders => [:top, :bottom])
	    style(row(0).columns(0), :borders => [:top, :left, :bottom])
	    style(row(0).columns(-1), :borders => [:top, :right, :bottom])
	    style(row(-1), :border_width => 2)
	    style(column(2..-1), :align => :left)
	    style(columns(0), :width => 75)
	    style(columns(1), :width => 225)
	    style(columns(4), :width => 50)
	  end

	  move_down 25

	  invoice_terms_data = [
	    ["Terminos"],
	    ["El presente PDF solo es para control interno."]
	  ]

	  table(invoice_terms_data, :width => 275) do
	    style(row(0..-1).columns(0..-1), :padding => [1, 0, 1, 0], :borders => [])
	    style(row(0).columns(0), :font_style => :bold)
	  end

	  move_down 15

	  invoice_notes_data = [
	    ["SINESSS"],
	    ["Trabajando por Ti y para Ti."],
	    ["CONSEJO EJECUTIVO NACIONAL 2013-2016"],
	    ["Lic. Elmer Mascaro Perez - Secretario General"]
	  ]

	  table(invoice_notes_data, :width => 275) do
	    style(row(0..-1).columns(0..-1), :padding => [1, 0, 1, 0], :borders => [])
	    style(row(0).columns(0), :font_style => :bold)
	  end
	end
end