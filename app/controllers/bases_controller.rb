class BasesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_basis, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def index
    respond_to do |format|
      format.html
      format.json { render json: BasesDatatable.new(view_context) }
    end
  end

  def show
    authorize! :show, Base
    @junta = @basis.juntas.where(status:'VIGENTE').last
    @juntas = @basis.juntas
  end

  # GET /bases/new
  def new
    authorize! :new, Base
    @basis = Base.new
  end

  # GET /bases/1/edit
  def edit
    authorize! :edit, Base
  end

  # POST /bases
  # POST /bases.json
  def create
    authorize! :create, Base
    @basis = Base.new(basis_params)
    if @basis.save
      redirect_to @basis, notice: 'Se registró correctamente la base.'
    else
      flash.now[:alert] = 'Hubo un problema. No se registró la base.'
      render action: 'new'
    end
  end

  # PATCH/PUT /bases/1
  # PATCH/PUT /bases/1.json
  def update
    authorize! :update, Base
    if @basis.update(basis_params)
      redirect_to @basis, notice: 'Se actualizó correctamente la base.'
    else
      flash.now[:alert] = 'Hubo un problema. No se pudo actualizar los datos.'
      render action: 'edit'    
    end
  end

  # DELETE /bases/1
  # DELETE /bases/1.json
  def destroy
    authorize! :destroy, Base
    @basis.destroy
    redirect_to bases_url, notice: 'Se eliminó correctamente la base.'
  end

  def flujo_mensual
    authorize! :flujo_mensual, Base
    @basis = Base.find(params[:basis_id])
    if request.xhr?
      unless params[:cotizacion]
        @cotizacion = get_full_fecha
        @money_contratados = Pago.sum_por_fecha_base_archivo(@cotizacion, @basis.codigo_base, 'NOMBRADOS Y CONTRATADOS')
        @money_cas = Pago.sum_por_fecha_base_archivo(@cotizacion, @basis.codigo_base, 'CAS')
        @money_total = @money_contratados + @money_cas
        @asignacion = @money_total/2
      end
    end
    respond_to do |format|
      format.html
      format.js { render 'bases/ajax_js/flujo_mensual' }
      format.json { render json: FlujosDatatable.new(view_context, @basis.codigo_base) }
    end
  end
  def miembros
    authorize! :miembros, Base
    if !request.xhr?
      @basis = Base.find(params[:basis_id])
    end
    respond_to do |format|
      format.html 
      format.json { render json: BasesMiembrosDatatable.new(view_context) }
    end
  end
  def estadisticas
    authorize! :estadisticas, Base
    @basis = Base.find(params[:basis_id])
    if request.xhr?
      @year = params[:date][:year]
    end
    respond_to do |format|
      format.html
      format.js { render 'bases/ajax_js/base_estadisticas' }
    end
  end 

  def import    
    authorize! :import, Base
    if !request.xhr?
      redirect_to bases_path, alert: 'No autorizado.'
    else
      render :layout => false
    end
  end
  def importar
    authorize! :importar, Base
    importacion = Import.new(status:'ESPERA',archivo: params[:archivo], tipo_clase: 'Bases',
                            descripcion: params[:descripcion], formato_org: 'SINESSS')
    if importacion.save
      Base.delay.import_bases(importacion)
      redirect_to imports_path, notice:'El proceso de importacion durará unos minutos.'
    else
      redirect_to bases_path, alert: 'El archivo es muy grande, o tiene un formato incorrecto.'
    end    
  end
  def import_juntas
    authorize! :import_juntas, Base
    if !request.xhr?
      redirect_to bases_path, alert: 'No autorizado.'
    else
      render :layout => false
    end    
  end
  def importar_juntas
    authorize! :importar_juntas, Base
    importacion = Import.new(status:'ESPERA', archivo: params[:archivo], tipo_clase: 'Juntas',
                            descripcion: params[:descripcion], formato_org: 'SINESSS')
    if importacion.save
      Base.delay.import_juntas(importacion)
      redirect_to imports_path, notice:'El proceso de importacion durará unos minutos.'
    else
      redirect_to bases_path, alert: 'El archivo es muy grande, o tiene un formato incorrecto.'
    end    
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_basis
      @basis = Base.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def basis_params
      params.require(:base).permit(:codigo_base, :nombre_base)
    end
    def get_full_fecha
      if params[:date]
        Date.parse('15-' + params[:date][:month] + '-' + params[:date][:year]).to_s
      end
    end
end
