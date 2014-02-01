class EntesEnfermerasDatatable
  delegate :params, :h, :link_to, :number_to_currency, :sinesss? , to: :@view
  #include Rails.application.routes.url_helpers
  

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Enfermera.por_ente(params[:ente_id]).count,
      iTotalDisplayRecords: enfermeras.total_entries,
      aaData: data
    }
    #debugger
  end
  
private

  def data
    enfermeras.map do |enfermera|
      [
        ERB::Util.h(enfermera.cod_planilla),
        enfermera.full_name,
        sinesss?(enfermera.b_sinesss),
        link_to("<i class='fa fa-eye'></i> Ver datos".html_safe, "/enfermeras/#{enfermera.id}", :class => 'btn btn-success btn-xs' ),
      ]
    end
  end

  def enfermeras
    @enfermeras ||= fetch_enfermeras  
  end

  def fetch_enfermeras
    #enfermeras = Enfermera.order("full_name")
    enfermeras = Enfermera.where('ente_id = ?', params[:ente_id]).paginate(:page => page, :per_page => per_page).order("#{sort_column} #{sort_direction}")
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
    columns = %w[cod_planilla full_name b_sinesss full_name]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end