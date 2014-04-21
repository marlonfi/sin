class DonacionEnfermerasController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  layout 'admin'
  # GET /donacion_enfermeras
  # GET /donacion_enfermeras.json
  def index
    @enfermera = Enfermera.find(params[:enfermera_id])
    @donaciones = @enfermera.donaciones
  end

  # GET /donacion_enfermeras/new
  def new
    @enfermera = Enfermera.find(params[:enfermera_id])
    @donacion = @enfermera.donaciones.build
  end

  # GET /donacion_bases/1/edit
  def edit
    @enfermera = Enfermera.find(params[:enfermera_id])
    @donacion =  @enfermera.donaciones.find(params[:id])
  end

  # POST /donacion_enfermeras
  # POST /donacion_enfermeras.json
  def create
    @enfermera = Enfermera.find(params[:enfermera_id])
    @donacion = @enfermera.donaciones.build(donacion_enfermera_params)
    @donacion.generado_por = current_user.apellidos_nombres
    if @donacion.save
      redirect_to  enfermera_donacion_enfermeras_path(@enfermera), notice: 'Se registró correctamente.'
    else
      flash.now[:alert] = 'Hubo un problema. No se registró.'
      render action: 'new'      
    end
  end

  # PATCH/PUT /donacion_enfermeras/1
  # PATCH/PUT /donacion_enfermeras/1.json
  def update
    @enfermera = Enfermera.find(params[:enfermera_id])
    @donacion = @enfermera.donaciones.find(params[:id])
    @donacion.generado_por = current_user.apellidos_nombres
    if @donacion.update(donacion_enfermera_params)
      redirect_to enfermera_donacion_enfermeras_path(@enfermera), notice: 'Se actualizó correctamente.'
    else
      flash.now[:alert] = 'Hubo un problema. No se pudo actualizar los datos.'
      render action: 'edit'
    end
  end

  # DELETE /donacion_enfermeras/1
  # DELETE /donacion_enfermeras/1.json
  def destroy
    @enfermera = Enfermera.find(params[:enfermera_id])
    @donacion = @enfermera.donaciones.find(params[:id])
    @donacion.destroy
    redirect_to enfermera_donacion_enfermeras_path(@enfermera), notice: "Se eliminó correctamente el registro."
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def donacion_enfermera_params
      params.require(:donacion_enfermera).permit(:monto, :fecha_entrega, :motivo, :descripcion)
    end
end
