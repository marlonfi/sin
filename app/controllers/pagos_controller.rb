class PagosController < ApplicationController
	before_filter :authenticate_user!
  layout 'admin'

  def index
    @bases = Base.all 	
  end
  def new
    @enfermera = Enfermera.find(params[:enfermera_id])
    @bases = Base.all
  end
  def create
    debugger
  end
  def retrasos
    if params[:cotizacion]
      @cotizacion = params[:cotizacion]
    elsif params[:date]
      @cotizacion = get_full_fecha
    else
      @cotizacion = Time.now.strftime("%d-%m-%Y").to_s
    end
    @pagos = Pago.includes(:enfermera).where('generado_por = ? AND mes_cotizacion =  ?', 'Falta de pago', @cotizacion)
  end
  def listar
    if request.xhr?
      if params[:codigo_base]
        @codigo_base = params[:codigo_base]
      else
        @codigo_base = params[:base][:codigo_base] == '' ? 'Pago libre' : params[:base][:codigo_base]
      end
      unless params[:cotizacion]
        @cotizacion = get_full_fecha
        @money_contratados = Pago.sum_por_fecha_base_archivo(@cotizacion, @codigo_base, 'NOMBRADOS Y CONTRATADOS')
        @money_cas = Pago.sum_por_fecha_base_archivo(@cotizacion, @codigo_base, 'CAS')
        @money_total = @money_contratados + @money_cas
        @asignacion = @money_total/2
      end
    end
    respond_to do |format|
      format.html { redirect_to pagos_path, alert: 'No autorizado.' }
      format.js { render 'pagos/ajax_js/flujo_mensual' }
      format.json { render json: FlujosDatatable.new(view_context, @codigo_base) }
    end
  end
  def import
  	if !request.xhr?
      redirect_to pagos_path, alert: 'No autorizado.'
    else
      render :layout => false
    end  
  end
  def importar
  	fecha = get_full_fecha
  	importacion = Import.new(status: 'ESPERA', archivo: params[:archivo],
  													 tipo_clase: 'Pagos', tipo_txt: params[:tipo],
  													 formato_org: 'ESSALUD', fecha_pago: fecha )
    if importacion.save
      Pago.delay.import(importacion)
      redirect_to imports_path, notice:'El proceso de importacion durará unos minutos.'
    else
      redirect_to pagos_path, alert: 'El archivo es muy grande, o tiene un formato incorrecto.'
    end
  end
  private
  def get_full_fecha()
  	if params[:date]
  		Date.parse('15-' + params[:date][:month] + '-' + params[:date][:year]).to_s
  	end
  end
end
