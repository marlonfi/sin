class ReportsController < ApplicationController
  layout 'admin'

  def index
    
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
end
