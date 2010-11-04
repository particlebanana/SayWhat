class Ability
  include CanCan::Ability

  def initialize(user)
    
    if !user
      can :request_group, Group
      can :create, Group
      can :pending_request, Group
      #can :login, User
    elsif user.admin?
      can :manage, :all
    end
      
  end
end