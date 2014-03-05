class ReportsController < ApplicationController
  layout 'admin'
  def index
    @bases = Base.all
  end  
  def bases_aportaciones
  end
  def pagos_faltantes
  end
  def bases_miembros
  end
end
