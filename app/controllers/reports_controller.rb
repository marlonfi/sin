class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_autorizacion
  layout 'admin'
  
  def index
    @bases = Base.order(:codigo_base)
  end  
  def bases_aportaciones
    fecha = get_full_fecha()
    base = params[:base][:codigo_base] == '' ? 'Pago libre' : params[:base][:codigo_base]
    pagos = Pago.includes(:enfermera).por_fecha_base(fecha, base)
    pagos = pagos.where('archivo = ? OR archivo =  ?', 'CAS', 'NOMBRADOS Y CONTRATADOS')
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

  def bases_aportaciones_voucher
    fecha = get_full_fecha()
    base = params[:base][:codigo_base] == '' ? 'Pago libre' : params[:base][:codigo_base]
    pagos = Pago.includes(:enfermera).por_fecha_base(fecha, base)
    pagos = pagos.where('archivo = ?', 'VOUCHER')
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = AgremiadosVoucherPdf.new(pagos,base,fecha,view_context)
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

  def aportaciones_por_base_voucher
    fecha = get_full_fecha()
    red_y_bases = RedAsistencial.with_bases
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = RedesBasesVoucherPdf.new(red_y_bases, fecha, view_context)
        send_data pdf.render, filename: "Bases_y_cotizaciones_#{fecha}.pdf",
                              type: "application/pdf",
                              disposition: "inline"

      end
    end
  end

  def donaciones_bases
    fecha_inicio = Date.parse('1-' + '1' + '-' + params[:date][:year]).to_s
    fecha_fin = Date.parse('31-' + '12' + '-' + params[:date][:year]).to_s
    donaciones = DonacionBase.includes(:base).where("release_date >= ? AND release_date <= ?", fecha_inicio, fecha_fin)
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = DonacionesBasesPdf.new(donaciones, fecha_inicio, fecha_fin, view_context)
        send_data pdf.render, filename: "Donaciones_bases_#{params[:date][:year]}.pdf",
                              type: "application/pdf",
                              disposition: "inline"

      end
    end
  end
  def asignaciones_enfermeras
    fecha_inicio = Date.parse('1-' + '1' + '-' + params[:date][:year]).to_s
    fecha_fin = Date.parse('31-' + '12' + '-' + params[:date][:year]).to_s
    donaciones = DonacionEnfermera.includes(:enfermera).where("fecha_entrega >= ? AND fecha_entrega <= ?", fecha_inicio, fecha_fin)
    respond_to do |format|
      format.html
      format.pdf do 
        pdf = DonacionesEnfermerasPdf.new(donaciones, fecha_inicio, fecha_fin, view_context)
        send_data pdf.render, filename: "Asignaciones_enfermeras_#{params[:date][:year]}.pdf",
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
  def check_autorizacion
    unless current_user.admin? || current_user.organizacional? || current_user.reader?
      redirect_to dashboard_path, alert: 'No authorizado'
    end
  end 
end
