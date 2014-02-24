class Pago < ActiveRecord::Base
	def self.import(import)
		@paginas, @enfermeras = 0, 0
		@import_file = import	
		@data_trabajo = {}
		path = import.archivo.path
		file = File.new(path)
		file.each_line do |line|
	  	new_line = line.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
	  	process_data_from_txt(new_line)
	  end
	  import.update_attributes(descripcion: "Paginas: #{@paginas} - Enfermeras: #{@enfermeras}")	  
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
				@enfermeras = @enfermeras + 1
				make_chages(data_enfermera)
				#process_payment(data: new_line, programa: programa, subprograma: subprograma, actividad: actividad, act1: act1)
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
end
