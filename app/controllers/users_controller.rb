class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  load_and_authorize_resource
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
  end

  private

  def user_params
    params.require(:user).permit(:dni, :apellidos_nombres, :cargo, :superadmin, :admin, :informatica,
                             :organizacional, :reader, :desabilitado)
  end
end

