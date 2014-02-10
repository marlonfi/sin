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
		path = import.archivo.path
		CSV.foreach(path, headers: true) do |row|
		  if row['PROGRAMA'] == 'SALUD'
		  	if row['SUB PROGRA'][0..2] == 'RA '
		  		red = RedAsistencial.find_by_cod_essalud(row['SUB PROGRA'])
		  		if red
			  		case row['ACTIVIDAD']
			  		when 'Ger.Red Asist.'
			  			ente = find_or_create_by(cod_essalud: "Ger.Red Asist."+"-"+ red.cod_essalud)
			  			red.entes << ente
			  		when 'Dir.Red Asist'
			  			ente = find_or_create_by(cod_essalud: "Dir.Red Asist"+"-"+ red.cod_essalud)
			  			red.entes << ente
			  		when 'Dir.Red Asist.'
			  			ente = find_or_create_by(cod_essalud: "Dir.Red Asist"+"-"+ red.cod_essalud)
			  			red.entes << ente 
			  		else
			  			if row['ACTIVIDAD'] == 'PM San Miguel'
			  				ente = find_or_create_by(cod_essalud: "PM San Miguel"+"-"+ red.cod_essalud)
			  				red.entes << ente 		  				
			  			else
			  				ente = find_or_create_by(cod_essalud: row['ACTIVIDAD'])
			  				red.entes << ente
			  			end
			  		end
			  	end	
		  	elsif row['SUB PROGRA'] == 'INCOR'
		  		red = RedAsistencial.find_by_cod_essalud('ORG. DESCONCENTRADOS')
		  		if red
			  		ente = find_or_create_by(cod_essalud: 'INCOR')
			  		red.entes << ente
			  	end
		  	elsif row['SUB PROGRA'] == 'CN Salud Rena'
		  		red = RedAsistencial.find_by_cod_essalud('ORG. DESCONCENTRADOS')
		  		if red
			  		ente = find_or_create_by(cod_essalud: 'CN Salud Rena')
			  		red.entes << ente
			  	end
		  	elsif row['SUB PROGRA'] == 'Programa CEI'
		  		red = RedAsistencial.find_by_cod_essalud('ORG. DESCONCENTRADOS')
		  		if red
			  		ente = find_or_create_by(cod_essalud: 'Programa CEI')
			  		red.entes << ente
			  	end
		  	elsif row['SUB PROGRA'] == 'Def.del Asegu'
		  		red = RedAsistencial.find_by_cod_essalud(row['SUB ACTIV1'])
					if red
						ente =  find_or_create_by(cod_essalud: 'Def.del Asegu' +'-'+ red.cod_essalud)
						red.entes << ente
					end
				elsif row['SUB PROGRA'] == 'GC Pre.Soc.y'
					red = RedAsistencial.find_by_cod_essalud(row['SUB ACTIV1'])
					if red
						ente =  find_or_create_by(cod_essalud: 'GC Pre.Soc.y' +'-'+ red.cod_essalud)
						red.entes << ente
					end
				elsif row['SUB PROGRA'] == 'Org.Ctrol.Ins'
					red = RedAsistencial.find_by_cod_essalud(row['ACTIVIDAD'])
					if red
						ente =  find_or_create_by(cod_essalud: 'Org.Ctrol.Ins' +'-'+ red.cod_essalud)
						red.entes << ente	
					end	  		
		  	elsif row['SUB PROGRA'] == 'GC Prest Salu'
		  		red = RedAsistencial.find_by_cod_essalud('ORG. DESCONCENTRADOS')
		  		if row['SUB ACTIV1'] == 'Despacho'
		  			if red
			  			ente = find_or_create_by(cod_essalud: 'Despacho-GCPS')
			  			red.entes << ente
			  		end
		  		else
			  		if red	
			  			ente = find_or_create_by(cod_essalud: row['SUB ACTIV1'])
			  			red.entes << ente
			  		end
			  	end
		  	end	
		  elsif row['PROGRAMA'] == 'AFESSALUD'
		  	red = RedAsistencial.find_by_cod_essalud('ORG. DESCONCENTRADOS')
		  	if red
		  		if row['CONDICION'] == 'CAS'
			  		ente = find_or_create_by(cod_essalud: 'AFESSALUD-CRUEN')
			  		red.entes << ente
			  	else
			  		ente = find_or_create_by(cod_essalud: 'AFESSALUD-SEDE_CENTRAL')
			  		red.entes << ente
			  	end	
			  end
		  end	
		end
	end
end
