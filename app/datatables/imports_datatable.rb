class ImportsDatatable
  delegate :params, :h, :print_status, :month_year, :date_and_hour, :link_to, to: :@view
  #include Rails.application.routes.url_helpers
  
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Import.count,
      iTotalDisplayRecords: imports.total_entries,
      aaData: data
    }
  end
  
private
  def data
    imports.map do |import|
      [
        print_status(import.status).html_safe,
        import.tipo_clase,
        month_year(import.fecha_pago),
        import.tipo_txt,
        import.formato_org,
        date_and_hour(import.created_at),
        link_to(File.basename(import.archivo_url), "imports/#{import.id}/download", :target => "_blank"),
        import.descripcion        
      ]
    end
  end

  def imports
    @imports ||= fetch_imports  
  end

  def fetch_imports
    imports = Import.paginate(:page => page, :per_page => per_page).order("#{sort_column} #{sort_direction}")
    if params[:sSearch].present?
      imports = imports.where("status ilike :search or tipo_clase ilike :search", search: "%#{params[:sSearch]}%")
    end
    imports
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[status tipo_clase fecha_pago tipo_txt formato_org created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end