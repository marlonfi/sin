class PagosReportMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  add_template_helper(ImportsHelper)
  default :from => 'no-reply@sinesss.org'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_pagos_status(enfermera)
    @enfermera = enfermera
    @base = enfermera.base
    @primero = Import.where(tipo_clase: 'Pagos').last.fecha_pago
    @segundo = @primero- 1.month
    @tercero = @primero- 2.month
    @pago1 = @enfermera.pagos.where(mes_cotizacion: @primero).first
    @pago2 = @enfermera.pagos.where(mes_cotizacion: @segundo).first
    @pago3 = @enfermera.pagos.where(mes_cotizacion: @tercero).first
    mail( :to => 'wcpaez@gmail.com',
    :subject => 'Información sobre estado de aportaciones.' )
  end
end
