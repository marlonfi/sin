class FlujosDatatable
  delegate :params, :h, :link_to, :number_to_currency, :month_year , to: :@view
  #include Rails.application.routes.url_helpers  

  def initialize(view, codigo_base)
    @view = view
    @codigo_base = codigo_base
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Pago.por_fecha_base(params[:cotizacion], @codigo_base).count,
      iTotalDisplayRecords: pagos.total_entries,
      aaData: data
    }
    #debugger
  end
  
private

  def data
    pagos.map do |pago|
      enfermera = pago.enfermera
      base = pago.base == 'Pago libre' ? "Pago libre (#{pago.ente_libre})" : pago.base
      [
        link_to(enfermera.full_name, "/enfermeras/#{enfermera.id}"),
        base,
        month_year(pago.mes_cotizacion),
        number_to_currency(pago.monto, :unit => "S/. "),
        pago.generado_por
      ]
    end
  end

  def pagos
    @pagos ||= fetch_pagos
  end

  def fetch_pagos
    pagos = Pago.por_fecha_base(params[:cotizacion], @codigo_base).
                 paginate(:page => page, :per_page => per_page).
                 order("#{sort_column} #{sort_direction}")
    return pagos
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[enfermera_id base mes_cotizacion monto generado_por]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end