class JuntasController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'  
  
  def new
    @basis = Base.find(params[:basis_id])
    @junta = @basis.juntas.build
  end

  # GET /enfermeras/1/edit
  def edit
    @basis = Base.find(params[:basis_id])
    @junta = Junta.find(params[:junta_id])
  end
  #get
 
 
  def create
    @basis = Base.find(params[:basis_id])
    @junta = @basis.juntas.build(secretaria_general: params[:junta][:secretaria_general],
                                 numero_celular: params[:junta][:numero_celular],
                                 email: params[:junta][:email],
                                 status: params[:junta][:status],
                                 inicio_gestion: params[:junta][:inicio_gestion],
                                 fin_gestion: params[:junta][:fin_gestion],
                                 descripcion: params[:junta][:descripcion])
    if @junta.save
      redirect_to basis_path(@basis), notice: 'Se registró correctamente la Junta Directiva'
    else
      flash.now[:alert] = 'No se pudo regitrar la nueva Junta.'
      render 'new'
    end    
  end

  def update
    @basis = Base.find(params[:basis_id])
    @junta = Junta.find(params[:junta_id])
    if @junta.update(secretaria_general: params[:junta][:secretaria_general],
                                 numero_celular: params[:junta][:numero_celular],
                                 email: params[:junta][:email],
                                 status: params[:junta][:status],
                                 inicio_gestion: params[:junta][:inicio_gestion],
                                 fin_gestion: params[:junta][:fin_gestion],
                                 descripcion: params[:junta][:descripcion])
      redirect_to basis_path(@basis), notice: 'Se actualizó correctamente la enfermera.'
    else
      flash.now[:alert] = 'Hubo un problema. No se pudo actualizar los datos.'
      render action: 'edit'
    end
    
  end
  def destroy
    @basis = Base.find(params[:basis_id])
    @junta = Junta.find(params[:junta_id])
    @junta.destroy
    redirect_to basis_path(@basis), notice: 'Se eliminó correctamente la Junta Directiva'
  end

end
