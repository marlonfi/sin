class DonacionBase < ActiveRecord::Base
	belongs_to :base
	validates_presence_of :base_id, :product_name, :release_date
	validates :product_name, length: { maximum: 250 }
	validates :category, length: { maximum: 250 }
	validates :descripcion, length: { maximum: 1000 }
	validates :generado_por, length: { maximum: 250 }
	validates_date :release_date
end
