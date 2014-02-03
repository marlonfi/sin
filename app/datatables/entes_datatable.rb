class EntesDatatable
  delegate :params, :h, :link_to, :number_to_currency, :sinesss?, :mostrar_base , to: :@view
  #include Rails.application.routes.url_helpers
  

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Ente.count,
      iTotalDisplayRecords: entes.total_entries,
      aaData: data
    }

  end
  
private

  def data
    entes.map do |ente|
      [
        ente.cod_essalud,
        ente.nombre,
        link_to(ente.red_asistencial.cod_essalud, "/red_asistencials/#{ente.red_asistencial.id}/entes"),
        mostrar_base(ente),
        link_to("Ver <span class='badge bg-primary'>#{ente.enfermeras.count}</span> enfermeras".html_safe,
               "/entes/#{ente.id}/enfermeras"),
        link_to("<i class='fa fa-eye'></i> Ver   ".html_safe,
                "/entes/#{ente.id}", :class => 'btn btn-success btn-xs' )+ " " +
        link_to("<i class='fa fa-pencil'></i> Editar".html_safe,
                "/entes/#{ente.id}/edit", :class => 'btn btn-primary btn-xs' ),
      ]
    end
  end

  def entes
    @entes ||= fetch_entes  
  end

  def fetch_entes
    #entes = ente.order("full_name")
    entes = Ente.paginate(:page => page, :per_page => per_page).order("#{sort_column} #{sort_direction}")
    if params[:sSearch].present?
      entes = entes.where("cod_essalud ilike :search or nombre ilike :search", search: "%#{params[:sSearch]}%")
    end
    entes
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[cod_essalud]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end