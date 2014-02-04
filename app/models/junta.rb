class Junta < ActiveRecord::Base
	belongs_to :base
	validates_presence_of :secretaria_general, :inicio_gestion, :fin_gestion, :base_id
	validates :email, length: { maximum: 250 }
	validates :secretaria_general, length: { maximum: 250 }
  validates :numero_celular, length: { maximum: 250 }
  validates :descripcion, length: { maximum: 1020 }
  validate  :email_regex
  validates_date :inicio_gestion, :fin_gestion
  validates_inclusion_of :status, :in => ['FINALIZADO', 'VIGENTE']
  scope :vigente, -> { where(status: 'VIGENTE').last }
	private
 	def email_regex
    if email.present? and not email.match(/\A[^@]+@[^@]+\z/)
      errors.add :email, "formato incorrecto"
    end
  end
end
