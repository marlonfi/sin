class EnfermerasController < ApplicationController
  before_action :set_enfermera, only: [:show, :edit, :update, :destroy]
  layout 'admin'
  # GET /enfermeras
  # GET /enfermeras.json
  def index
    #@enfermeras = Enfermera.first(100)#.paginate(:page => params[:page], :per_page => 25)
    respond_to do |format|
      format.html
      format.json { render json: EnfermerasDatatable.new(view_context) }
    end
  end

  # GET /enfermeras/1
  # GET /enfermeras/1.json
  def show
  end

  # GET /enfermeras/new
  def new
    @enfermera = Enfermera.new
  end

  # GET /enfermeras/1/edit
  def edit
  end
  #get
  def import_essalud
    if !request.xhr?
      redirect_to red_asistencials_path, alert: 'No autorizado.'
    else
      render :layout => false
    end
  end
  #post
  def importar_essalud
    importacion = Import.new(archivo: params[:archivo], tipo_clase: 'Enfermeras',
                            descripcion: params[:descripcion], formato_org: 'ESSALUD')
    if importacion.save
      Enfermera.import_essalud(importacion)
      redirect_to dashboard_path, notice:'El proceso de importacion durará unos minutos.'
    else
      redirect_to entes_path, alert: 'El archivo es muy grande, o tiene un formato incorrecto.'
    end
  end
  # POST /enfermeras
  # POST /enfermeras.json
  def create
    @enfermera = Enfermera.new(enfermera_params)

    if @enfermera.save
      redirect_to @enfermera, notice: 'Se registró correctamente la enfermera'
    else
      flash.now[:alert] = 'Hubo un problema. No se registró la enfermera'
      render action: 'new'      
    end
    
  end

  # PATCH/PUT /enfermeras/1
  # PATCH/PUT /enfermeras/1.json
  def update
    if @enfermera.update(enfermera_params)
      redirect_to @enfermera, notice: 'Se actualizó correctamente la enfermera.'
    else
      flash.now[:alert] = 'Hubo un problema. No se pudo actualizar los datos.'
      render action: 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enfermera
      @enfermera = Enfermera.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def enfermera_params
      params.require(:enfermera).permit(:ente_id, :cod_planilla, :apellido_paterno, :apellido_materno, :nombres, :email, :regimen, :b_sinesss, :b_fedcut, :b_famesalud, :b_excel)
    end
end