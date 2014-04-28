class EmailsDatatable
  delegate :params, :h, :print_status,:fecha_con_formato, :month_year, :date_and_hour, :link_to, to: :@view
  #include Rails.application.routes.url_helpers
  
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: EnvioEmail.count,
      iTotalDisplayRecords: emails.total_entries,
      aaData: data
    }
  end
  
private
  def data
    emails.map do |email|
      [
        print_status(email.status).html_safe,
        fecha_con_formato(email.fecha_envio),
        month_year(email.ultimo_mes_enviado),
        email.emails_enviados,
        email.emails_no_enviados,
        email.generado_por   
      ]
    end
  end

  def emails
    @emails ||= fetch_emails 
  end

  def fetch_emails
    emails = EnvioEmail.paginate(:page => page, :per_page => per_page).order("#{sort_column} #{sort_direction}")
    if params[:sSearch].present?
      emails = emails.where("status ilike :search", search: "%#{params[:sSearch]}%")
    end
    emails
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[status fecha_envio ultimo_mes_enviado emails_enviados emails_no_enviados generado_por]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end