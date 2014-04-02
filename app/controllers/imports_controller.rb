class ImportsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  def index
    respond_to do |format|
      format.html
      format.json { render json: ImportsDatatable.new(view_context) }
    end
  end
  
  def download
    @resource = Import.find(params[:import_id])
    if @resource
      send_file(@resource.archivo.path,
                :disposition => 'attachment',
                :url_based_filename => false)
    else
      redirect_to imports_path, alert: 'Prohibed'
    end
  end 
end
