class EnfermerasController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_authorize_resource :only => [:index, :anual_chart]
  before_action :set_enfermera, only: [:show, :edit, :update, :destroy]
  layout 'admin'
  # GET /enfermeras
  # GET /enfermeras.json
  def index
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
  
  def aportaciones
    @enfermera = Enfermera.find(params[:enfermera_id])
    @aportaciones = @enfermera.pagos.paginate(:page => params[:page], :per_page => 12).
                    order(mes_cotizacion: :desc)
  end
  def bitacoras
    @enfermera = Enfermera.find(params[:enfermera_id])
    @bitacoras = @enfermera.bitacoras.order(created_at: :desc)
  end
  def create
    @enfermera = Enfermera.new(enfermera_params)

    if @enfermera.save
      redirect_to @enfermera, notice: 'Se registró correctamente la enfermera'
    else
      flash.now[:alert] = 'Hubo un problema. No se registró la enfermera'
      render action: 'new'      
    end    
  end

  def update
    if @enfermera.update(enfermera_update_params)
      redirect_to @enfermera, notice: 'Se actualizó correctamente la enfermera.'
    else
      flash.now[:alert] = 'Hubo un problema. No se pudo actualizar los datos.'
      render action: 'edit'
    end
  end

  def anual_chart
    @year = params[:date][:year]
  end

  def import_essalud
    if !request.xhr?
      redirect_to enfermeras_path, alert: 'No autorizado.'
    else
      render :layout => false
    end
  end
  #post
  def importar_essalud
    importacion = Import.new(status: 'ESPERA', archivo: params[:archivo], tipo_clase: 'Enfermeras',
                            descripcion: params[:descripcion], formato_org: 'ESSALUD')
    if importacion.save
      Enfermera.delay.import_essalud(importacion)
      redirect_to imports_path, notice:'El proceso de importacion durará unos minutos.'
    else
      redirect_to enfermeras_path, alert: 'El archivo es muy grande, o tiene un formato incorrecto.'
    end
  end

  #get modal para importar data actualiada
  def import_data_actualizada
    if !request.xhr?
      redirect_to enfermeras_path, alert: 'No autorizado.'
    else
      render :layout => false
    end
  end

  #metodo para la importacion csv de data actualizadoa
  def importar_data_actualizada
    importacion = Import.new(status: 'ESPERA', archivo: params[:archivo], tipo_clase: 'Enfermeras',
                            descripcion: params[:descripcion], formato_org: 'SINESSS')
    if importacion.save
      Enfermera.delay.import_data_actualizada(importacion)
      redirect_to imports_path, notice:'El proceso de importacion durará unos minutos.'
    else
      redirect_to enfermeras_path, alert: 'El archivo es muy grande, o tiene un formato incorrecto.'
    end
  end

  #METODO D LOS BOTONES DE AFILIACON Y DESAFILIACION
  def afiliacion_desafiliacion
    @enfermera = Enfermera.find(params[:enfermera_id])
    afiliado = @enfermera.b_sinesss
    @enfermera.afiliar_desafiliar(params[:descripcion])
    redirect_to @enfermera, notice: "Se #{afiliado ? 'desafilió' : 'afilió'} la enfermera al sindicato." 
  end
  #metodo de lo btones pra transladar enfermera
  def trasladar
    @enfermera = Enfermera.find(params[:enfermera_id])
    if params[:ente][:cod_essalud] == ''
      redirect_to @enfermera, alert: 'Para trasladar un enfermera, no olvide seleccionar el nuevo lugar de trabajo.'
    else
      ente_final = Ente.find_by_cod_essalud(params[:ente][:cod_essalud])
      if ente_final
        ente_inicial = @enfermera.ente
        @enfermera.trasladar(ente_inicial, ente_final, params[:descripcion])
        redirect_to @enfermera, notice: "Se trasladó a la enfermera del lugar de trabajo '#{ente_inicial.cod_essalud}' a '#{ente_final.cod_essalud}' "
      else
        redirect_to @enfermera, alert: 'No se encontro el nuevo ente en la base de datos.'
      end   
    end
  end

  private

  def set_enfermera
    @enfermera = Enfermera.find(params[:id])
  end

  def enfermera_update_params
    params.require(:enfermera).permit(:cod_planilla, :apellido_paterno, :apellido_materno, :nombres, :email,
                             :regimen, :b_fedcut, :b_famesalud, :b_excel, :dni,
                             :sexo, :factor_sanguineo, :fecha_nacimiento, :domicilio_completo, :telefono,
                             :telefono, :fecha_inscripcion_sinesss, :fecha_ingreso_essalud, :especialidad,
                             :maestria, :doctorado)
  end
  def enfermera_params
    params.require(:enfermera).permit(:ente_id, :cod_planilla, :apellido_paterno, :apellido_materno, :nombres, :email,
                             :regimen, :b_sinesss, :b_fedcut, :b_famesalud, :b_excel, :dni,
                             :sexo, :factor_sanguineo, :fecha_nacimiento, :domicilio_completo, :telefono,
                             :telefono, :fecha_inscripcion_sinesss, :fecha_ingreso_essalud, :especialidad,
                             :maestria, :doctorado)
  end
end
