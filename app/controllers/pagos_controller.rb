class PagosController < ApplicationController
	before_filter :authenticate_user!
  load_and_authorize_resource
  skip_authorize_resource :only => [:index]
  layout 'admin'

  def index
    @bases = Base.all 	
  end
  def new
    @enfermera = Enfermera.find(params[:enfermera_id])
    @bases = Base.all
  end
  def create
    @enfermera = Enfermera.find(params[:enfermera_id])
    fecha = get_full_fecha()
    base = params[:base][:codigo_base] == '' ? 'Pago libre' : params[:base][:codigo_base]
    @pago = @enfermera.pagos.build(monto: params[:monto], mes_cotizacion: fecha, base: base,
                      ente_libre: @enfermera.ente.cod_essalud, voucher: params[:voucher],
                      comentario: params[:comentario], generado_por: current_user.apellidos_nombres,
                      archivo: 'VOUCHER')
    if @pago.save
      #deletes if there is a pago faltante with that same mes_contizacion
      pago_retrasado = @enfermera.pagos.
                  where('generado_por = ? AND mes_cotizacion =  ?', 'Falta de pago', fecha).first
      if pago_retrasado
        pago_retrasado.destroy
      end       
      redirect_to enfermera_aportaciones_path(@enfermera), notice: 'Se registró correctamente el pago.'
    else
      @bases = Base.all
      flash.now[:alert] = 'Hubo un problema. No se registró. Revisar el monto.'
      render action: 'new'      
    end 
  end


  def edit
    @enfermera = Enfermera.find(params[:enfermera_id])
    @aportacion = @enfermera.pagos.find(params[:id])
    @bases = Base.all
    if (DateTime.now.to_date - 15.days) > @aportacion.created_at
       redirect_to enfermera_aportaciones_path(@enfermera), alert: "UD. ya no puede editar este pago."
    else
      render
    end
  end
  def update
    @enfermera = Enfermera.find(params[:enfermera_id])
    @aportacion = @enfermera.pagos.find(params[:id])
    fecha = get_full_fecha()
    base = params[:base][:codigo_base] == '' ? 'Pago libre' : params[:base][:codigo_base]
    if (DateTime.now.to_date - 15.days) > @aportacion.created_at
       redirect_to enfermera_aportaciones_path(@enfermera), alert: "UD. ya no puede editar este pago."
    else
      log = @aportacion.log || ''
      @aportacion.log = log + "(#{@aportacion.monto} || #{@aportacion.mes_cotizacion} || #{@aportacion.base} ||
                #{@aportacion.generado_por} ||  #{@aportacion.archivo} ||  #{@aportacion.voucher})"
      if @aportacion.update_attributes(monto: params[:monto], mes_cotizacion: fecha, base: base,
                      ente_libre: @enfermera.ente.cod_essalud, voucher: params[:voucher],
                      comentario: params[:comentario], generado_por: current_user.apellidos_nombres,
                      archivo: 'VOUCHER')
        redirect_to enfermera_aportaciones_path(@enfermera), notice: 'Se actualizó correctamente el pago'
      else
        @bases = Base.all
        flash.now[:alert] = 'Hubo un problema. No se actualizó. Revisar el monto.'
        render action: 'edit'
      end      
    end
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
        @money_voucher = Pago.sum_por_fecha_base_archivo(@cotizacion, @codigo_base, 'VOUCHER')
        @money_total = @money_contratados + @money_cas + @money_voucher
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
    importado = Import.where("tipo_clase = ? AND fecha_pago = ? AND tipo_txt = ?",
                             'Pagos', fecha, params[:tipo]).first
    #ultimo_importado = Import.where("tipo_clase = ?", 'Pagos' ).last
    if importado #|| (Date.parse(get_full_fecha) < ultimo_importado.fecha_pago)#para no dejar importar dos veces el mismo archivo
      redirect_to pagos_path, alert: 'Ya se importó ese archivo, revisar el log de importaciones.'
    else
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
  end
  private
  def get_full_fecha()
  	if params[:date]
  		Date.parse('15-' + params[:date][:month] + '-' + params[:date][:year]).to_s
  	end
  end
end
