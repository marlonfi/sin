#encoding: utf-8
class RedAsistencialsController < ApplicationController
  before_action :set_red_asistencial, only: [:show, :edit, :update, :destroy]
  layout 'admin'
  def index
    @red_asistencials = RedAsistencial.order(cod_essalud: :asc)
  end
  
  def new
    @red_asistencial = RedAsistencial.new
  end

  def edit
  end

  def create
    @red_asistencial = RedAsistencial.new(red_asistencial_params)
    if @red_asistencial.save
      redirect_to(red_asistencials_path,
                  notice: "Se registró correctamente la red asistencial #{@red_asistencial.cod_essalud}.")
    else
      flash.now[:alert] = 'Hubo un problema. No se registró la red asistencial.'
      render action: 'new'
    end
  end

  def update
    if @red_asistencial.update(red_asistencial_params)
      redirect_to red_asistencials_path, notice: "Se actualizó correctamente la red asistencial #{@red_asistencial.cod_essalud}."
    else
      flash.now[:alert] = 'Hubo un problema. No se pudo actualizar los datos.'
      render action: 'edit'
    end
  end
  

  def destroy
    @red_asistencial.destroy
    redirect_to red_asistencials_path, notice: "Se eliminó correctamente la red asistencial"
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
