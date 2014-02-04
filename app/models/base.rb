class Base < ActiveRecord::Base
	has_many :entes, :dependent => :nullify
	has_many :juntas, :dependent => :destroy
	has_many :enfermeras, through: :entes
	validates_presence_of :codigo_base
	validates_uniqueness_of :codigo_base, :case_sensitive => false
	validates :codigo_base, length: { maximum: 250 }
	validates :nombre_base, length: { maximum: 250 }
	
	def self.import_bases(import)
		path = import.archivo.path
		CSV.foreach(path) do |row|
			base = find_or_create_by(codigo_base: row.shift)
			row.each do |ente_id|
				if ente_id
					ente = Ente.find_by_cod_essalud(ente_id)
					if ente
						base.entes << ente
					end
				end
			end	  	
		end
	end

	def self.import_juntas(import)
		path = import.archivo.path
		CSV.foreach(path, headers: true) do |row|
			base = find_by_codigo_base(row['codigo_base'])
			if base
				if !base.juntas.any?
					base.juntas.create(secretaria_general: row['secretaria_general'],
														inicio_gestion: row['inicio_gestion'],
														fin_gestion: row['fin_gestion'],
														status: row['status'],
														numero_celular: row['numero_celular'],
														email: row['email'],
														descripcion: row['descripcion'])
				end
			end	  	
		end
	end
	
end
