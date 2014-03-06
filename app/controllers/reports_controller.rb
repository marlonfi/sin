class ReportsController < ApplicationController
  layout 'admin'
  def index
    @bases = Base.order(:codigo_base)
  end  
  def bases_aportaciones
    fecha = get_full_fecha()
    base = params[:base][:codigo_base] == '' ? 'Pago libre' : params[:base][:codigo_base]
    pagos = Pago.includes(:enfermera).por_fecha_base(fecha, base)
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = AgremiadosPdf.new(pagos,base,fecha,view_context)
        send_data pdf.render, filename: "#{base}_mes_cotizacion_#{fecha}.pdf",
                              type: "application/pdf",
                              disposition: "inline"

      end
    end
  end

  def pagos_faltantes
    fecha = get_full_fecha()
    pagos = Pago.includes(:enfermera).por_fecha(fecha).where(generado_por: 'Falta de pago')
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = PagosFaltantesPdf.new(pagos,fecha,view_context)
        send_data pdf.render, filename: "Pagos_faltantes_mes_cotizacion_#{fecha}.pdf",
                              type: "application/pdf",
                              disposition: "inline"

      end
    end
  end
  def bases_miembros
    base = Base.find_by_codigo_base(params[:base][:codigo_base])
    if base
      respond_to do |format|
        format.html
        format.pdf do 
          pdf = BasesMiembrosPdf.new(base, view_context)
          send_data pdf.render, filename: "#{base.codigo_base}_miembros#{Time.now.strftime("%d-%m-%Y")}.pdf",
                                type: "application/pdf",
                                disposition: "inline"

        end
      end
    else
       redirect_to reports_path, alert: 'No se encuentra la base'
    end
  end
  def entes_sin_base
    entes = Ente.includes(:red_asistencial,:enfermeras).where(base_id: nil)
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = EntesPdf.new(entes,view_context)
        send_data pdf.render, filename: "Entes_sin_base_#{Time.now.strftime("%d-%m-%Y").to_s}.pdf",
                              type: "application/pdf",
                              disposition: "inline"

      end
    end
  end

  def aportaciones_por_base
    fecha = get_full_fecha()
    red_y_bases = RedAsistencial.with_bases
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = RedesBasesPdf.new(red_y_bases, fecha, view_context)
        send_data pdf.render, filename: "Bases_y_cotizaciones_#{fecha}.pdf",
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
