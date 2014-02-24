class Import < ActiveRecord::Base
	mount_uploader :archivo, ArchivoUploader
	validates_presence_of :tipo_clase
	validates_presence_of :archivo
	validates_presence_of :status
	validates_presence_of :formato_org
	validates_date :fecha_pago, :allow_blank => true
	validates_inclusion_of :status, :in => ['PROCESANDO', 'IMPORTADO',
																				 'ERROR', 'ESPERA']
  validates_inclusion_of :formato_org, :in => ['ESSALUD', 'SINESSS']
  validates_inclusion_of :tipo_txt, :in => ['CAS', 'NOMBRADOS Y CONTRATADOS'], :allow_blank => true  
	validates_inclusion_of :tipo_clase, :in => ['Enfermeras', 'Redes Asistenciales',
																						'Entes', 'Juntas', 'Bases', 'Pagos' ]
end
