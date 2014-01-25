class RedAsistencial < ActiveRecord::Base
	validates_presence_of :cod_essalud
	validates_uniqueness_of :cod_essalud
	validates :cod_essalud, length: { maximum: 250 }
	validates :contacto_nombre, length: { maximum: 250 }
	validates :contacto_telefono, length: { maximum: 250 }
end
