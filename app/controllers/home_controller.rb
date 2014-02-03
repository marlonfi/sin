class HomeController < ApplicationController
	layout 'admin'
  def dashboard
  	@bases = Base.all  	
  end
end
