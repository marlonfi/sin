class HomeController < ApplicationController
  def dashboard
  	@bases = Base.all
  	render :layout => 'admin'  	
  end
  def principal
  	render :layout => 'principal'
  end
end
