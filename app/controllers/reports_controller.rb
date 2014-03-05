class ReportsController < ApplicationController
  layout 'admin'

  def index
    @bases = Base.all
  end
  
  def send_payments_reports
  	enfermera1 = Enfermera.find_by_cod_planilla('1824580')#traslado
  	enfermera2 = Enfermera.find_by_cod_planilla('4339600')#recienafiliado
  	enfermera3 = Enfermera.find_by_cod_planilla('3467956')#retraso aportacion
  	enfermera4 = Enfermera.find_by_cod_planilla('4601114')#sin base
  	PagosReportMailer.send_pagos_status(enfermera1).deliver
  	PagosReportMailer.send_pagos_status(enfermera2).deliver
  	PagosReportMailer.send_pagos_status(enfermera3).deliver
  	PagosReportMailer.send_pagos_status(enfermera4).deliver
  	redirect_to reports_path, notice: 'Emails enviados.'
  end

  def pdf
    fecha = get_full_fecha()
    base = params[:base][:codigo_base] == '' ? 'Pago libre' : params[:base][:codigo_base]
    pagos = Pago.includes(:enfermera).por_fecha_base(fecha, base)
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = AgremiadoPdf.new(pagos,base,fecha,view_context)
        send_data pdf.render, filename: "#{base}_mes_cotizacion_#{fecha}.pdf",
                              type: "application/pdf",
                              disposition: "inline"

      end
    end
  end

  private
  def get_full_fecha()
    if params[:date]
      Date.parse('15-' + params[:date][:month] + '-' + params[:date][:year]).to_s
    end
  end 
end
