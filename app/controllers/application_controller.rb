class ApplicationController < ActionController::Base
	before_action :set_notifications
	#http_basic_authenticate_with name: "iokero", password: "clavemuysegura"
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def set_notifications
  	@total_notificaciones = Bitacora.pendientes.count
  	@total_afiliaciones = Bitacora.pendientes.where(tipo: 'AFILIACION').count
  	@total_desafiliaciones = Bitacora.pendientes.where(tipo: 'DESAFILIACION').count
  	@total_traslados = Bitacora.pendientes.where(tipo: 'TRASLADO').count
  	@total_otros = Bitacora.pendientes.where(tipo: 'OTROS').count 
  end
end
