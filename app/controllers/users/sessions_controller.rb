class Users::SessionsController < Devise::SessionsController
  layout "principal"
  def new
  	super
  end
end