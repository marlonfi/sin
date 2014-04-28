class CotizacionesMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  add_template_helper(ImportsHelper)
  default :from => "no-reply@sinesss.org"

  def estado_cotizaciones_email(enfermera, ultima_cotizacion)
  	@enfermera = enfermera
  	@base = enfermera.base
    @primero = ultima_cotizacion
    @segundo = ultima_cotizacion - 1.month
    @tercero = ultima_cotizacion - 2.month
    @pago1 = @enfermera.pagos.where(mes_cotizacion: @primero).first
    @pago2 = @enfermera.pagos.where(mes_cotizacion: @segundo).first
    @pago3 = @enfermera.pagos.where(mes_cotizacion: @tercero).first
    mail( :to => @enfermera.email,
    :subject => 'SINESSS - Información sobre estado de aportaciones.' )
  end
end
