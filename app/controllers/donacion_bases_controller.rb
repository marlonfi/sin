class DonacionBasesController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'  
  # GET /donacion_bases
  # GET /donacion_bases.json
  def index
    authorize! :index, DonacionBase
    @basis = Base.find(params[:basis_id])
    @donaciones = @basis.donaciones
  end

  def new
    authorize! :new, DonacionBase
    @basis = Base.find(params[:basis_id])
    @donacion = @basis.donaciones.build
  end

  # GET /donacion_bases/1/edit
  def edit
    authorize! :edit, DonacionBase
    @basis = Base.find(params[:basis_id])
    @donacion = @basis.donaciones.find(params[:id])
  end

  # POST /donacion_bases
  # POST /donacion_bases.json
  def create
    authorize! :create, DonacionBase
    @basis = Base.find(params[:basis_id])
    @donacion = @basis.donaciones.build(donacion_basis_params)
    @donacion.generado_por = current_user.apellidos_nombres
    if @donacion.save
      redirect_to basis_donacion_bases_path(@basis.id), notice: 'Se registró correctamente.'
    else
      flash.now[:alert] = 'Hubo un problema. No se registró.'
      render action: 'new'      
    end
  end

  # PATCH/PUT /donacion_bases/1
  # PATCH/PUT /donacion_bases/1.json
  def update
    authorize! :update, DonacionBase
    @basis = Base.find(params[:basis_id])
    @donacion = @basis.donaciones.find(params[:id])
    @donacion.generado_por = current_user.apellidos_nombres
    if @donacion.update(donacion_basis_params)
      redirect_to basis_donacion_bases_path(@basis.id), notice: 'Se actualizó correctamente.'
    else
      flash.now[:alert] = 'Hubo un problema. No se pudo actualizar los datos.'
      render action: 'edit'
    end
  end

  def destroy
    authorize! :destroy, DonacionBase
    @basis = Base.find(params[:basis_id])
    @donacion = @basis.donaciones.find(params[:id])
    @donacion.destroy
    redirect_to basis_donacion_bases_path(@basis.id), notice: "Se eliminó correctamente el registro."
  end
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def donacion_basis_params
    params.require(:donacion_base).permit(:product_name, :category, :release_date, :descripcion, :generado_por)
  end
end
