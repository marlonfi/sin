class BasesController < ApplicationController
  before_action :set_basis, only: [:show, :edit, :update, :destroy]
  layout 'admin'
  # GET /bases
  # GET /bases.json
  def import_juntas
    if !request.xhr?
      redirect_to bases_path, alert: 'No autorizado.'
    else
      render :layout => false
    end
  end
  def importar_juntas
    importacion = Import.new(archivo: params[:archivo], tipo_clase: 'Juntas',
                            descripcion: params[:descripcion], formato_org: 'SINESSS')
    if importacion.save
      Base.delay.import_juntas(importacion)
      redirect_to dashboard_path, notice:'El proceso de importacion durará unos minutos.'
    else
      redirect_to bases_path, alert: 'El archivo es muy grande, o tiene un formato incorrecto.'
    end
  end
  
  def miembros
    if !request.xhr?
      @basis = Base.find(params[:basis_id])
    end
    respond_to do |format|
      format.html 
      format.json { render json: BasesMiembrosDatatable.new(view_context) }
    end
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: BasesDatatable.new(view_context) }
    end
  end

  def import
    if !request.xhr?
      redirect_to bases_path, alert: 'No autorizado.'
    else
      render :layout => false
    end
  end
  def importar
    importacion = Import.new(archivo: params[:archivo], tipo_clase: 'Bases',
                            descripcion: params[:descripcion], formato_org: 'SINESSS')
    if importacion.save
      Base.delay.import_bases(importacion)
      redirect_to dashboard_path, notice:'El proceso de importacion durará unos minutos.'
    else
      redirect_to bases_path, alert: 'El archivo es muy grande, o tiene un formato incorrecto.'
    end
  end
  # GET /bases/1
  # GET /bases/1.json
  def show
    @junta = @basis.juntas.where(status:'VIGENTE').last
    @juntas = @basis.juntas
  end

  # GET /bases/new
  def new
    @basis = Base.new
  end

  # GET /bases/1/edit
  def edit
  end

  # POST /bases
  # POST /bases.json
  def create
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
    @basis.destroy
    redirect_to bases_url, notice: 'Se eliminó correctamente la base.'
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
end
