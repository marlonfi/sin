class Ente < ActiveRecord::Base
	belongs_to :red_asistencial
	belongs_to :base
	has_many :enfermeras
	validates_presence_of :red_asistencial
	validates_presence_of :cod_essalud
	validates_uniqueness_of :cod_essalud, :case_sensitive => false
	validates :contacto_nombre, length: { maximum: 250 }
	validates :contacto_numero, length: { maximum: 250 }
	validates :cod_essalud, length: { maximum: 250 }
	validates :direccion, length: { maximum: 250 }
	validates :nombre, length: { maximum: 250 }
	
	def self.import(import)
		begin
			import.update_attributes(status: 'PROCESANDO')
			path = import.archivo.path
			CSV.foreach(path, headers: true) do |row|
				data_enfermera, data_trabajo = Enfermera.parse_row(row)
				parse_entes(data_trabajo, data_enfermera[:regimen])
			end
			import.update_attributes(status: 'IMPORTADO')
		rescue
			import.update_attributes(status: 'ERROR')
		end
	end
	
	#parsea data_trabajo en crea ente
	def self.parse_entes(data_trabajo, regimen)
		nombre_ente = Ente.get_ente_name(data_trabajo, regimen)
		if data_trabajo[:programa] == 'SALUD'
	  	if data_trabajo[:sub_programa][0..2] == 'RA '
	  		red = RedAsistencial.find_by_cod_essalud(data_trabajo[:sub_programa])
	  		crear_ente(red, nombre_ente)
	  	elsif data_trabajo[:sub_programa] == 'Def.del Asegu'
	  		red = RedAsistencial.find_by_cod_essalud(data_trabajo[:sub_actividad1])
				crear_ente(red, nombre_ente)
			elsif data_trabajo[:sub_programa] == 'GC Pre.Soc.y'
				red = RedAsistencial.find_by_cod_essalud(data_trabajo[:sub_actividad1])
				crear_ente(red, nombre_ente)
			elsif data_trabajo[:sub_programa] == 'Org.Ctrol.Ins'
				red = RedAsistencial.find_by_cod_essalud(data_trabajo[:actividad])
				crear_ente(red, nombre_ente)		
	  	else
	  		red = RedAsistencial.find_by_cod_essalud('ORG. DESCONCENTRADOS')
	  		crear_ente(red, nombre_ente)
	  	end
	  elsif data_trabajo[:programa] == 'AFESSALUD'
	  	red = RedAsistencial.find_by_cod_essalud('ORG. DESCONCENTRADOS')
	  	crear_ente(red, nombre_ente)
	  end	
	end
	def self.crear_ente(red, nombre_ente)
		if red
			ente = find_or_create_by(cod_essalud: nombre_ente)
			red.entes << ente
			ente
		end
	end

	def self.get_ente_name(data_trabajo, regimen)
		if data_trabajo[:programa] == 'SALUD'
      if data_trabajo[:sub_programa][0..2] == 'RA '
        case data_trabajo[:actividad]
        when 'Ger.Red Asist.'
          return "Ger.Red Asist."+"-"+ data_trabajo[:sub_programa]
        when 'Dir.Red Asist'
          return "Dir.Red Asist"+"-"+ data_trabajo[:sub_programa]
        when 'Dir.Red Asist.'
          return "Dir.Red Asist"+"-"+ data_trabajo[:sub_programa]
        else
          if data_trabajo[:actividad] == 'PM San Miguel'
            return "PM San Miguel"+"-"+ data_trabajo[:sub_programa]
          else
            return data_trabajo[:actividad]
          end
        end
      elsif data_trabajo[:sub_programa] == 'INCOR'
        return 'INCOR'
      elsif data_trabajo[:sub_programa] == 'CN Salud Rena'
        return 'CN Salud Rena'
      elsif data_trabajo[:sub_programa] == 'Programa CEI'
        return 'Programa CEI'
      elsif data_trabajo[:sub_programa] == 'Def.del Asegu'
        return 'Def.del Asegu' +'-'+ data_trabajo[:sub_actividad1]
      elsif data_trabajo[:sub_programa] == 'GC Pre.Soc.y'
        return 'GC Pre.Soc.y' +'-'+ data_trabajo[:sub_actividad1]
      elsif data_trabajo[:sub_programa] == 'Org.Ctrol.Ins'
        return 'Org.Ctrol.Ins' +'-'+ data_trabajo[:actividad]
      elsif data_trabajo[:sub_programa] == 'GC Prest Salu'
        if data_trabajo[:sub_actividad1] == 'Despacho'
          return 'Despacho-GCPS'
        else
          return data_trabajo[:sub_actividad1]
        end
      end          
    elsif data_trabajo[:programa] == 'AFESSALUD'
      if regimen == 'CAS'
        return 'AFESSALUD-CRUEN'
      else
        return 'AFESSALUD-SEDE_CENTRAL'
      end
    end
	end
	# devuelve el ente a partir de los datos de trabajo
  def self.get_ente(data_trabajo, regimen)
  	return Ente.find_by_cod_essalud(get_ente_name(data_trabajo, regimen))
  end


end
