# app/mailer_previews/user_mailer_preview.rb:
class PagosMailerPreview
  # preview methods should return Mail objects, e.g.:
  def send_pagos_status       
    enfermera1 = Enfermera.find_by_cod_planilla('1824580')
    PagosReportMailer.send_pagos_status(enfermera1)
  end
  def send_pagos_status1       
    enfermera1 = Enfermera.find_by_cod_planilla('4339600')
    PagosReportMailer.send_pagos_status(enfermera1)
  end
  def send_pagos_status2      
    enfermera1 = Enfermera.find_by_cod_planilla('3467956')
    PagosReportMailer.send_pagos_status(enfermera1)
  end
  def send_pagos_status3     
    enfermera1 = Enfermera.find_by_cod_planilla('4601114')
    PagosReportMailer.send_pagos_status(enfermera1)
  end
end