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
       
       can :index, Import
       can :download, Import
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
    end
    if user.reader?
       can :show, RedAsistencial
       can :entes, RedAsistencial

       can :show, Ente
       can :enfermeras, Ente 
    end
    if user.admin?       
       can :show, RedAsistencial
       can :entes, RedAsistencial

       can :show, Ente
       can :enfermeras, Ente  
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
