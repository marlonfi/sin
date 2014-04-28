class CotizacionesMailer < ActionMailer::Base
  default from: "no-responder@sinesss.org"

  def estado_cotizaciones_email(enfermera, ultima_cotizacion)
  	@enfermera = enfermera
  	@base = enfermera.base
    @pago1 = @enfermera.pagos.where(mes_cotizacion: ultima_cotizacion).first
    @pago2 = @enfermera.pagos.where(mes_cotizacion: ultima_cotizacion - 1.month).first
    @pago3 = @enfermera.pagos.where(mes_cotizacion: ultima_cotizacion - 2.month).first
    mail( :to => @enfermera.email,
    :subject => 'Información sobre estado de aportaciones al SINESSS.' )
  end
end
