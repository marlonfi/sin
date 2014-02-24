class PagosController < ApplicationController
	layout 'admin'
  def index 	
  end

  def import
  	if !request.xhr?
      redirect_to pagos_path, alert: 'No autorizado.'
    else
      render :layout => false
    end  
  end
  def importar
  	fecha = get_fecha(params[:date])
  	importacion = Import.new(status: 'ESPERA', archivo: params[:archivo],
  													 tipo_clase: 'Pagos', tipo_txt: params[:tipo],
  													 formato_org: 'ESSALUD', fecha_pago: fecha )
    if importacion.save
      Pago.import(importacion)
      redirect_to imports_path, notice:'El proceso de importacion durará unos minutos.'
    else
      redirect_to pagos_path, alert: 'El archivo es muy grande, o tiene un formato incorrecto.'
    end
  end
  private
  def get_fecha(date)
  	if date
  		'15-' + params[:date][:month] + '-' + params[:date][:year]
  	end
  end
end
