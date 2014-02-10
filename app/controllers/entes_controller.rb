class EntesController < ApplicationController
  before_action :set_ente, only: [:show, :edit, :update, :destroy]
  layout 'admin'
  # GET /entes
  # GET /entes.json

  def enfermeras
    if !request.xhr?
      @ente = Ente.find(params[:ente_id])
    end
    respond_to do |format|
      format.html { render 'ente_enfermeras' }
      format.json { render json: EntesEnfermerasDatatable.new(view_context) }
    end
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: EntesDatatable.new(view_context) }
    end
  end

  # GET /entes/1
  # GET /entes/1.json
  def show
    @red = @ente.red_asistencial
  end

  # GET /entes/new
  def new
    @redes = RedAsistencial.all
    @bases = Base.all
    @ente = Ente.new
  end

  # GET /entes/1/edit
  def edit
    @redes = RedAsistencial.all
    @bases = Base.all
  end

  def import
    if !request.xhr?
      redirect_to entes_path, alert: 'No autorizado.'
    else
      render :layout => false
    end
  end

  def importar
    importacion = Import.new(archivo: params[:archivo], tipo_clase: 'Entes',
                            descripcion: params[:descripcion], formato_org: 'ESSALUD')
    if importacion.save
      Ente.delay.import(importacion)
      redirect_to dashboard_path, notice:'El proceso de importacion durará unos minutos.'
    else
      redirect_to entes_path, alert: 'El archivo es muy grande, o tiene un formato incorrecto.'
    end
  end 
  # POST /entes
  # POST /entes.json
  def create
    @ente = Ente.new(ente_params)
    if @ente.save
      redirect_to @ente, notice: 'Se registró correctamente el ente.'
    else
      @redes = RedAsistencial.all
      @bases = Base.all
      flash.now[:alert] = 'Hubo un problema. No se registró el ente.'
      render action: 'new'
    end
  end

  # PATCH/PUT /entes/1
  # PATCH/PUT /entes/1.json
  def update
    if @ente.update(ente_params)
      redirect_to @ente, notice: 'Se actualizó correctamente el ente.'
    else
      @redes = RedAsistencial.all
      @bases = Base.all
      flash.now[:alert] = 'Hubo un problema. No se pudo actualizar los datos.'
      render action: 'edit'
    end
  end

  # DELETE /entes/1
  # DELETE /entes/1.json
  def destroy
    @ente.destroy
    redirect_to entes_path, notice: "Se eliminó correctamente el ente."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ente
      @ente = Ente.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ente_params
      params.require(:ente).permit(:red_asistencial_id, :base_id, :cod_essalud, :nombre, :contacto_nombre, :contacto_numero, :direccion, :latitud, :longitud)
    end
end
