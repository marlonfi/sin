class BitacorasDatatable
  delegate :params, :h, :link_to,:status_bitacora, to: :@view
  #include Rails.application.routes.url_helpers
  

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Bitacora.pendientes.count,
      iTotalDisplayRecords: bitacoras.total_entries,
      aaData: data
    }
    #debugger
  end
  
private

  def data
    bitacoras.map do |bitacora|
      enfermera = bitacora.enfermera
      [
        link_to(enfermera.full_name, "/enfermeras/#{enfermera.id}"),
        bitacora.tipo,
        bitacora.created_at.strftime("%d/%m/%Y a las %I:%M%p"),
        status_bitacora(bitacora.status).html_safe,
        bitacora.ente_inicio,
        bitacora.ente_fin,
        bitacora.descripcion
      ]
    end
  end

  def bitacoras
    @bitacoras ||= fetch_bitacoras 
  end

  def fetch_bitacoras
    if !params[:tipo]
      bitacoras = Bitacora.pendientes.
                  paginate(:page => page, :per_page => per_page).
                  order("#{sort_column} #{sort_direction}")
    else
      bitacoras = Bitacora.pendientes.where("tipo = ? ", params[:tipo].upcase).
                  paginate(:page => page, :per_page => per_page).
                  order("#{sort_column} #{sort_direction}")
    end
    if params[:sSearch].present?
      bitacoras = bitacoras.where("tipo ilike :search", search: "%#{params[:sSearch]}%")
    end
    bitacoras
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[enfermera_id tipo created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end