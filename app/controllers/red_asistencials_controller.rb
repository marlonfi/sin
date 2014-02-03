#encoding: utf-8
class RedAsistencialsController < ApplicationController
  before_action :set_red_asistencial, only: [:edit, :update, :destroy]
  layout 'admin'
  def index
    @red_asistencials = RedAsistencial.order(cod_essalud: :asc)
  end
  
  def new
    @red_asistencial = RedAsistencial.new
  end

  def edit
  end
  def entes
    @red_asistencial = RedAsistencial.find(params[:red_asistencial_id])
    @entes = @red_asistencial.entes
    render 'ra_entes'
  end
  def import
    if !request.xhr?
      redirect_to red_asistencials_path, alert: 'No autorizado.'
    else
      render :layout => false
    end  
  end

  def importar
    importacion = Import.new(archivo: params[:archivo], tipo_clase: 'Red Asistencial',
                            descripcion: params[:descripcion], formato_org: 'ESSALUD')
    if importacion.save
      RedAsistencial.delay.import(importacion)
      redirect_to dashboard_path, notice:'El proceso de importacion durará unos minutos.'
    else
      redirect_to red_asistencials_path, alert: 'El archivo es muy grande, o tiene un formato incorrecto.'
    end
  end 

  def create
    @red_asistencial = RedAsistencial.new(red_asistencial_params)
    if @red_asistencial.save
      redirect_to(red_asistencials_path,
                  notice: "Se registró correctamente la red asistencial: #{@red_asistencial.cod_essalud}.")
    else
      flash.now[:alert] = 'Hubo un problema. No se registró la red asistencial.'
      render action: 'new'
    end
  end

  def update
    if @red_asistencial.update(red_asistencial_params)
      redirect_to red_asistencials_path, notice: "Se actualizó correctamente la red asistencial: #{@red_asistencial.cod_essalud}."
    else
      flash.now[:alert] = 'Hubo un problema. No se pudo actualizar los datos.'
      render action: 'edit'
    end
  end
  

  def destroy
    @red_asistencial.destroy
    redirect_to red_asistencials_path, notice: "Se eliminó correctamente la red asistencial."
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_red_asistencial
      @red_asistencial = RedAsistencial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def red_asistencial_params
      params.require(:red_asistencial).permit(:cod_essalud, :nombre, :contacto_nombre, :contacto_telefono)
    end
end
