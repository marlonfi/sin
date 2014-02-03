class BasesMiembrosDatatable
  delegate :params, :h, :link_to, :number_to_currency, :afiliado? , to: :@view
  #include Rails.application.routes.url_helpers
  

  def initialize(view)
    @view = view
    @base = Base.find(params[:basis_id])
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @base.enfermeras.total_sinesss.count,
      iTotalDisplayRecords: enfermeras.total_entries,
      aaData: data
    }
    #debugger
  end
  
private

  def data
    enfermeras.map do |enfermera|
      [
        enfermera.cod_planilla,
        enfermera.full_name,
        enfermera.ente.cod_essalud,
        afiliado?(enfermera.b_fedcut),
        afiliado?(enfermera.b_famesalud),
        link_to("<i class='fa fa-eye'></i> Ver datos".html_safe, "/enfermeras/#{enfermera.id}", :class => 'btn btn-success btn-xs' ),
      ]
    end
  end

  def enfermeras
    @enfermeras ||= fetch_enfermeras  
  end

  def fetch_enfermeras
    #enfermeras = Enfermera.order("full_name")
    enfermeras = @base.enfermeras.total_sinesss.paginate(:page => page, :per_page => per_page).order("#{sort_column} #{sort_direction}")
    if params[:sSearch].present?
      enfermeras = enfermeras.where("full_name ilike :search or cod_planilla ilike :search", search: "%#{params[:sSearch]}%")
    end
    enfermeras
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[cod_planilla full_name ente b_fedcut b_famesalud ]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end