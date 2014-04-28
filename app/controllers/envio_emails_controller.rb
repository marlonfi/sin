class EnvioEmailsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  layout 'admin'

  def index
    respond_to do |format|
      format.html
      format.json { render json: EmailsDatatable.new(view_context) }
    end
  end

  def enviar_emails
    ultimo_mes_importado = Import.check_double_import
    if ultimo_mes_importado
      ultimo_envio = EnvioEmail.where('ultimo_mes_enviado = ?', ultimo_mes_importado)
      if ultimo_envio.count >= 2
        redirect_to envio_emails_path, alert: 'Solo se pueden enviar 2 veces emails para la última cotización.'
      else
        @envio_email = EnvioEmail.create!(fecha_envio: Date.today, ultimo_mes_enviado: ultimo_mes_importado,
               emails_enviados: 0, emails_no_enviados: 0, generado_por: current_user.apellidos_nombres,
               status:'ESPERA', acumulado: 1 )
        @envio_email.procesar_emails
        redirect_to envio_emails_path, notice: 'Se iniciará el envio de emails.'
      end
    else
      redirect_to envio_emails_path, alert: 'Se tienen que tener tanto el block de notas de CAS y NOMBRADOS/CONTRATADOS importados.'
    end
  end

  private
  
  def envio_email_params
    params.require(:envio_email).permit(:fecha_envio, :ultimo_mes_enviado, :emails_enviados, :emails_no_enviados, :generado_por, :acumulado)
  end
end
