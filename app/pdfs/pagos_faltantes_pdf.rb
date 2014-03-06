class PagosFaltantesPdf < Prawn::Document
	delegate :month_year, :number_to_currency, :date_and_hour,  to: :@view
	def initialize(pagos,fecha,view)
		super()
		@pagos = pagos.sort_by { |obj| obj.enfermera.full_name }		
		@fecha = fecha
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

	  text_box "Pagos Faltantes", :at => [@address_x, cursor]
	  move_down @lineheight_y
	  text_box "Total: #{@pagos.count} pagos", :at => [@address_x, cursor]
	  move_down @lineheight_y

	  invoice_header_data = [
	    ["Mes correspondiente", month_year(Date.parse(@fecha))],
	    ["Generado", date_and_hour(Time.now)],
	    ["Motivo", 'Pagos faltantes']
	  ]

	  table(invoice_header_data, :position => @invoice_header_x, :width => 215) do
	    style(row(0..1).columns(0..1), :padding => [1, 5, 1, 5], :borders => [])
	    style(row(2), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
	    style(column(1), :align => :right)
	    style(row(2).columns(0), :borders => [:top, :left, :bottom])
	    style(row(2).columns(1), :borders => [:top, :right, :bottom])
	  end

	end

	def all_data
  	
	  move_down 45
	  all_pagos = []
	  @pagos.each do |pago|
	  	enfermera =  pago.enfermera
	  	all_pagos << [enfermera.cod_planilla,enfermera.full_name, pago.base, month_year(pago.mes_cotizacion),
	  							 number_to_currency(pago.monto, :unit => "S/. ")]
	  end
	  #debugger
	  invoice_services_data = 
	    [["Cod. Planilla", "Enfermera", "Base aportante", "Mes aportación", "Monto"]] +
	    all_pagos +
	    [[" ", " ", " ", " ", " "]]
	  

	  table(invoice_services_data, :width => bounds.width) do
	    style(row(1..-1).columns(0..-1), :padding => [4, 5, 4, 5], :borders => [:bottom], :border_color => 'dddddd')
	    style(row(0), :background_color => 'e9e9e9', :border_color => 'dddddd', :font_style => :bold)
	    style(row(0).columns(0..-1), :borders => [:top, :bottom])
	    style(row(0).columns(0), :borders => [:top, :left, :bottom])
	    style(row(0).columns(-1), :borders => [:top, :right, :bottom])
	    style(row(-1), :border_width => 2)
	    style(column(2..-1), :align => :right)
	    style(columns(0), :width => 75)
	    style(columns(1), :width => 225)
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