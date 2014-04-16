class BitacorasController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_action :set_bitacora, only: [:show, :edit, :update, :destroy]
  layout 'admin'
  # GET /bitacoras
  # GET /bitacoras.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: BitacorasDatatable.new(view_context) }
    end
  end

  def new
    @enfermera = Enfermera.find(params[:enfermera_id])
    @bitacora = @enfermera.bitacoras.build
  end

  # POST /bitacoras
  # POST /bitacoras.json
  def create
    @enfermera = Enfermera.find(params[:enfermera_id])
    @bitacora = @enfermera.bitacoras.build(bitacora_params)
    if @bitacora.save
      redirect_to enfermera_bitacoras_path(@enfermera), notice: 'Se registró correctamente.'
    else
      flash.now[:alert] = 'Hubo un problema. No se registró.'
      render action: 'new'      
    end 
  end
  def change_status
    @enfermera = Enfermera.find(params[:enfermera_id])
    @bitacora = Bitacora.find(params[:bitacora_id])
    @bitacora.change_status
    if @bitacora.save
      redirect_to enfermera_bitacoras_path(@enfermera), notice: 'Se cambió el status.'
    else
      redirect_to enfermera_bitacoras_path(@enfermera), alert: 'Hubo un problema.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bitacora
      @bitacora = Bitacora.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bitacora_params
      params.require(:bitacora).permit(:tipo, :status, :ente_inicio, :ente_fin, :descripcion)
    end
end
