class ImportsController < ApplicationController
  layout 'admin'

  def index
    respond_to do |format|
      format.html
      format.json { render json: ImportsDatatable.new(view_context) }
    end
  end
  
  def destroy
    @import = Import.find(params[:id])
    @import.destroy
    redirect_to imports_path, notice: 'Se eliminó correctamente el registro de Import de data.'
  end
end
