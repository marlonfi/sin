class HomeController < ApplicationController
  before_filter :authenticate_user!, only: [:dashboard]
  def dashboard
  	@bases = Base.all
  	render :layout => 'admin'  	
  end
  def principal
  	unless user_signed_in?
  		render :layout => 'principal'
  	else
  		redirect_to dashboard_path
  	end
  end
end
