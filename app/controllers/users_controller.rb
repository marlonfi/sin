class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  load_and_authorize_resource
  skip_authorize_resource :only => [:edit_password, :update_password, :mi_perfil]

  #for all users
  def mi_perfil
    @user = current_user
  end
  def edit_password
    @user = current_user
  end
  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(own_user_params)
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to dashboard_path, notice: 'Se ha cambiado su password correctamente.'
    else
      flash.now[:alert] = 'Hubo un problema. Recuerde que el password debe tener como minimo 8 caracteres.'
      render "edit_password"
    end
  end
  #for superadmin users
  def index
  	@users = User.paginate(:page => params[:page], :per_page => 10).
                    order(apellidos_nombres: :desc)
  end
  def new
  	@user = User.new
  end
  def create
    parameters = user_params
    parameters[:password] = params[:user][:dni]
    parameters[:password_confirmation] = params[:user][:dni]
    @user = User.new(parameters)
    if @user.save
      redirect_to users_path, notice: 'Se registró correctamente el usuario.'
    else
      flash.now[:alert] = 'Hubo un problema. No se registró el usuario'
      render action: 'new'      
    end 
  end
  def edit
    @user = User.find(params[:id])
  end
  def update
    @user = User.find(params[:id])
    if @user.superadmin && current_user == @user
      params[:user][:superadmin] = true
    end
    if @user.update(user_params)
      redirect_to users_path, notice: 'Se actualizó correctamente el usuario.'
    else
      flash.now[:alert] = 'Hubo un problema. No se pudo actualizar los datos.'
      render action: 'edit'
    end
  end

  def reset_password
    @user = User.find(params[:user_id])
    if current_user.id != @user.id
      @user.update_attributes(:password => @user.dni, :password_confirmation => @user.dni)
      flash[:notice] = "Se ha reseteado correctamente."
      redirect_to users_path
    else
      flash[:alert] = "Hubo un problema. No puedes resetear tu propio usuario"
      redirect_to users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:dni, :apellidos_nombres, :cargo, :superadmin, :admin, :informatica,
                             :organizacional, :reader, :desabilitado)
  end
  def own_user_params
    # NOTE: Using `strong_parameters` gem
    params.required(:user).permit(:password, :password_confirmation, :current_password)
  end
end

