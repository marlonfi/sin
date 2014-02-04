class BasesDatatable
  delegate :params, :h, :link_to, :number_to_currency, :sinesss? , to: :@view
  #include Rails.application.routes.url_helpers
  

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Base.count,
      iTotalDisplayRecords: bases.total_entries,
      aaData: data
    }
    #debugger
  end
  
private

  def data
    bases.map do |base|
      if base.juntas.where(status:'VIGENTE').last
        secretaria = base.juntas.where(status:'VIGENTE').last.secretaria_general
      end
      [
        base.codigo_base,
        base.nombre_base,
        secretaria,
        link_to("Ver <span class='badge bg-primary'>#{base.enfermeras.total_sinesss.count}</span> miembros".html_safe,
               "/bases/#{base.id}/miembros"),
        link_to("<i class='fa fa-eye'></i>".html_safe, "bases/#{base.id}", :class => 'btn btn-success btn-xs' )+ " " +
        link_to("<i class='fa fa-pencil'></i>".html_safe,
                "/bases/#{base.id}/edit", :class => 'btn btn-primary btn-xs' ),
      ]
    end
  end

  def bases
    @bases ||= fetch_bases 
  end

  def fetch_bases
    bases = Base.paginate(:page => page, :per_page => per_page).order("#{sort_column} #{sort_direction}")
    if params[:sSearch].present?
      bases = bases.where("codigo_base ilike :search or nombre_base ilike :search", search: "%#{params[:sSearch]}%")
    end
    bases
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[codigo_base nombre_base]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end