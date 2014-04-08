class ApplicationController < ActionController::Base
	before_action :set_notifications
	#http_basic_authenticate_with name: "iokero", password: "clavemuysegura"
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: 'Acceso denegado.'
  end
  private
  def set_notifications
  	@total_notificaciones = Bitacora.pendientes.count
  	@total_afiliaciones = Bitacora.pendientes.where(tipo: 'AFILIACION').count
  	@total_desafiliaciones = Bitacora.pendientes.where(tipo: 'DESAFILIACION').count
  	@total_traslados = Bitacora.pendientes.where(tipo: 'TRASLADO').count
  	@total_otros = Bitacora.pendientes.where(tipo: 'OTROS').count
    @ultimo_archivo_importado = Import.where(tipo_clase: 'Pagos').last
    if @ultimo_archivo_importado
      @total_impagos = Pago.where('generado_por = ? AND mes_cotizacion = ?', 'Falta de pago',
                                 @ultimo_archivo_importado.fecha_pago)
      @count_total_impagos = @total_impagos.count
    else
      @count_total_impagos = nil
    end
  end
end
