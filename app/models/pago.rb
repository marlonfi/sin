class Pago < ActiveRecord::Base
	belongs_to :enfermera
	validates_presence_of :enfermera_id, :monto, :mes_cotizacion, :base, :generado_por
	validates_date :mes_cotizacion

	scope :sum_por_fecha_archivo, ->(fecha,archivo) { where("mes_cotizacion = ? AND archivo = ?", fecha, archivo).sum(:monto) }
	scope :por_fecha, ->(fecha) {where('mes_cotizacion = ?', fecha)}
	scope :por_fecha_base, ->(fecha,base) { where("mes_cotizacion = ? AND base = ?", fecha, base) }
	scope :sum_por_fecha_base, ->(fecha,base) { por_fecha_base(fecha,base).sum(:monto)}
	scope :por_fecha_base_archivo, ->(fecha,base,archivo) { por_fecha_base(fecha,base).where("archivo = ?", archivo) }
	scope :sum_por_fecha_base_archivo, ->(fecha,base,archivo) { por_fecha_base_archivo(fecha,base,archivo).sum(:monto)}

	def self.import(import)
		begin
			import.update_attributes(status: 'PROCESANDO')
      @paginas, @enfermeras = 0, 0
			@import_file = import	
			@data_trabajo = {}
			path = import.archivo.path
			file = File.new(path)
			file.each_line do |line|
		  	new_line = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
		  	process_data_from_txt(new_line)
		  end
		  Enfermera.generate_empty_payments(@import_file.fecha_pago, @import_file.tipo_txt)
		  total_importado = 'S/. ' + Pago.sum_por_fecha_archivo(@import_file.fecha_pago,
		  													 @import_file.tipo_txt).to_s	
      import.update_attributes(status: 'IMPORTADO',
      												descripcion: "Paginas: #{@paginas} - Enfermeras: #{@enfermeras} - Monto: #{total_importado}")
    rescue
      import.update_attributes(status: 'ERROR')
    end		  
	end

	private
	def self.process_data_from_txt(new_line)
		if /^ESSALUD\s+PAGINA/.match(new_line)
			@paginas = @paginas + 1			
		elsif /^PROGRAMA\s+:\s+\d+\s+(.+)/.match(new_line)
			@data_trabajo[:programa] = new_line.match(/^PROGRAMA\s+:\s+\d+\s+(.+)/)[1].strip
		elsif /^SUB-PROGRAMA\s+:\s+\d+\s+(.+)/.match(new_line)
			@data_trabajo[:sub_programa] = new_line.match(/^SUB-PROGRAMA\s+:\s+\d+\s+(.+)/)[1].strip
		elsif /^ACTIVIDAD\s+:\s+\d+\s+(.+)/.match(new_line)
			@data_trabajo[:actividad] = new_line.match(/^ACTIVIDAD\s+:\s+\d+\s+(.+)/)[1].strip
		elsif /^S-ACTIVID.1\s+:\s+\d+\s+(.+)/.match(new_line)
			@data_trabajo[:sub_actividad1] = new_line.match(/^S-ACTIVID.1\s+:\s+\d+\s+(.+)/)[1].strip
		else
			new_line = new_line.split
			if new_line != [] && new_line[0].length == 7
				data_enfermera = {}				
				aportacion = new_line.pop
				data_enfermera[:cod_planilla] = new_line.shift
				data_enfermera[:apellido_paterno] = new_line[0]
				data_enfermera[:apellido_materno] = new_line[1]
				data_enfermera[:b_sinesss] = true
				if @import_file.tipo_txt == 'CAS'
					data_enfermera[:regimen] = 'CAS'
				else
					data_enfermera[:regimen] = 'CONTRATADO'
				end
				data_enfermera[:nombres] = new_line[2..-1].join(' ')				
				enfermera = make_chages(data_enfermera)
				enfermera.make_payment(aportacion, @import_file) if enfermera
				@enfermeras = @enfermeras + 1
			end
		end		
	end
	def self.make_chages(data_enfermera)
		enfermera , ente = get_enfermera_and_ente(data_enfermera)
		if enfermera
			if enfermera.b_sinesss
				if enfermera.ente != ente
					Enfermera.generar_bitacora_cambio_ente(enfermera, enfermera.ente.cod_essalud,
																								ente.cod_essalud, @import_file.id)   
          Enfermera.cambiar_ente(enfermera,ente)      
        end
			else
				enfermera.bitacoras.create(import_id: @import_file.id, tipo: 'AFILIACION',
                             		status: 'PENDIENTE', ente_inicio: ente.cod_essalud,
                              	ente_fin: ente.cod_essalud)
				enfermera.update_attributes(b_sinesss: true)
				if enfermera.ente != ente
					Enfermera.generar_bitacora_cambio_ente(enfermera, enfermera.ente.cod_essalud,
																								ente.cod_essalud, @import_file.id)   
          Enfermera.cambiar_ente(enfermera,ente)      
        end
			end
		else
			enfermera = Enfermera.crear_enfermera_por_txt(ente, data_enfermera)
			if enfermera
				enfermera.bitacoras.create(import_id: @import_file.id, tipo: 'AFILIACION',
                             		status: 'PENDIENTE', ente_inicio: ente.cod_essalud,
                              	ente_fin: ente.cod_essalud, descripcion: 'Nueva enfermera generada por el block de notas.')
			end
		end
		return enfermera
	end

	def self.get_enfermera_and_ente(data_enfermera)
		enfermera = Enfermera.find_by_cod_planilla(data_enfermera[:cod_planilla])
		ente = Ente.get_ente(@data_trabajo, @import_file.tipo_txt)
		if !ente
			#parsea data_Trabajo y crea ente
			ente = Ente.parse_entes(@data_trabajo, data_enfermera[:regimen])
		end
		return enfermera, ente
	end

	def self.ingresos_cen_ultimos_meses(lapso_meses)
		fecha_actual =  Date.parse(Time.now.strftime("%d-%m-%Y").to_s).change(day:15)
		meses = [fecha_actual]
		data = {}
		(1..lapso_meses).each do |n|
			meses << (fecha_actual - n.month)
		end
		meses.each do |mes|
			data[mes.strftime("%b, %Y")] = [(Pago.sum_por_fecha_archivo(mes.to_s, 'CAS')/2).to_f]
			data[mes.strftime("%b, %Y")] << (Pago.sum_por_fecha_archivo(mes.to_s, 'NOMBRADOS Y CONTRATADOS')/2).to_f
		end
		return data
	end
end
