class Users::SessionsController < Devise::SessionsController
  layout "principal"
  def new
  	super
  end

  protected
  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.desabilitado?
      sign_out resource
      flash[:alert] = "Usuario deshabilitado."
      root_path
    else
      super
    end
   end
end