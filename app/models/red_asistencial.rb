class RedAsistencial < ActiveRecord::Base
	has_many :entes
	validates_presence_of :cod_essalud
	validates_uniqueness_of :cod_essalud, :case_sensitive => false
	validates :cod_essalud, length: { maximum: 250 }
	validates :contacto_nombre, length: { maximum: 250 }
	validates :contacto_telefono, length: { maximum: 250 }
	validates :nombre, length: { maximum: 250 }

	def self.import(import)
		path = import.archivo.path
		CSV.foreach(path, headers: true) do |row|
			if row['SUB PROGRA'][0..2] == 'RA '
			  	find_or_create_by(cod_essalud: row['SUB PROGRA'])
			  end		  	
		end
		find_or_create_by(cod_essalud: 'ORG. DESCONCENTRADOS')
	end
end
