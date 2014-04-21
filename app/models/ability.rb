class Ability
  include CanCan::Ability

  def initialize(user)
    if user.superadmin?
       can :manage, User
    end
    if user.informatica?
       can :import, RedAsistencial
       can :importar, RedAsistencial

       can :import, Ente
       can :importar, Ente

       can :importar_data_actualizada, Enfermera
       can :import_data_actualizada, Enfermera
       can :import_essalud, Enfermera
       can :importar_essalud, Enfermera

       can :import, Base
       can :importar, Base
       can :import_juntas, Base
       can :importar_juntas, Base

       can :index, Import
       can :download, Import

       can :import, Pago
       can :importar, Pago
    end
    if user.organizacional?
       can :new, RedAsistencial
       can :create, RedAsistencial
       can :edit, RedAsistencial
       can :update, RedAsistencial
       can :destroy, RedAsistencial
       can :show, RedAsistencial
       can :entes, RedAsistencial

       can :new, Ente
       can :create, Ente
       can :edit, Ente
       can :update, Ente
       can :destroy, Ente
       can :show, Ente
       can :enfermeras, Ente

       
       can :new, Enfermera
       can :edit, Enfermera
       can :create, Enfermera
       can :update, Enfermera
       can :aportaciones, Enfermera
       can :bitacoras, Enfermera
       can :show, Enfermera

       can :new, Base
       can :create, Base
       can :edit, Base
       can :update, Base
       can :destroy, Base

       can :show, Base
       can :flujo_mensual, Base
       can :miembros, Base
       can :estadisticas, Base

       can :index, Bitacora
       can :new, Bitacora
       can :create, Bitacora
       can :change_status, Bitacora

       can :new, Junta
       can :create, Junta
       can :edit, Junta
       can :update, Junta
       can :destroy, Junta

       
       can :retrasos, Pago
       can :listar, Pago
  
       can :index, DonacionBase
       can :index, DonacionEnfermera
    end
    if user.reader?
       can :show, RedAsistencial
       can :entes, RedAsistencial

       can :show, Ente
       can :enfermeras, Ente

       can :aportaciones, Enfermera
       can :bitacoras, Enfermera
       can :show, Enfermera

       can :show, Base
       can :flujo_mensual, Base
       can :miembros, Base
       can :estadisticas, Base

       can :index, Bitacora

       can :retrasos, Pago
       can :listar, Pago

       can :index, DonacionBase
       can :index, DonacionEnfermera 
    end
    if user.admin?       
       can :show, RedAsistencial
       can :entes, RedAsistencial

       can :show, Ente
       can :enfermeras, Ente

       can :aportaciones, Enfermera
       can :bitacoras, Enfermera
       can :show, Enfermera
       
       can :show, Base
       can :flujo_mensual, Base
       can :miembros, Base
       can :estadisticas, Base 

       can :index, Bitacora

       can :retrasos, Pago
       can :listar, Pago

       can :index, DonacionBase
       can :edit, DonacionBase
       can :update, DonacionBase
       can :new, DonacionBase
       can :create, DonacionBase
       can :destroy, DonacionBase

       can :index, DonacionEnfermera
       can :edit, DonacionEnfermera
       can :update, DonacionEnfermera
       can :new, DonacionEnfermera
       can :create, DonacionEnfermera
       can :destroy, DonacionEnfermera 
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/bryanrite/cancancan/wiki/Defining-Abilities
  end
end
