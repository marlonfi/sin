class EnvioEmail < ActiveRecord::Base
	validates_presence_of :fecha_envio, :ultimo_mes_enviado, :emails_enviados,
												:emails_no_enviados, :generado_por
	validates :generado_por, length: { maximum: 250 }
	validates_date :fecha_envio, :ultimo_mes_enviado
	validates_numericality_of :emails_enviados, :emails_no_enviados, :acumulado
	validates_inclusion_of :status, :in => ['PROCESANDO', 'ENVIADO',
																				 'ERROR', 'ESPERA']

  def procesar_emails
  	begin
			self.update_attributes(status: 'PROCESANDO')
			total_con_email, total_sin_email = EnvioEmail.procesar_envio_emails_cotizaciones(self.ultimo_mes_enviado)
			self.update_attributes(status: 'ENVIADO', emails_enviados: total_con_email, emails_no_enviados: total_sin_email)
		rescue
			self.update_attributes(status: 'ERROR')
		end
  end
  private
  def self.procesar_envio_emails_cotizaciones(ultima_cotizacion)
  	enfermeras = Enfermera.total_sinesss
  	enfermeras_con_correo,
  	total_con_email,
  	total_sin_email  = EnvioEmail.enfermeras_con_correo(enfermeras)
  	return total_con_email, total_sin_email
  end
  def self.enfermeras_con_correo(enfermeras)
  	total_con_email = 0
  	total_sin_email = 0
  	enfermeras_con_email = []
  	enfermeras.each do |enfermera|
  		if enfermera.email && enfermera.email.match(/\A[^@]+@[^@]+\z/)
  			enfermeras_con_email << enfermera
  			total_con_email += 1
  		else
  			total_sin_email += 1
  		end
  	end
  	return enfermeras_con_email, total_con_email, total_sin_email
  end
end
