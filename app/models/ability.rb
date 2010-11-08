class Ability
  include CanCan::Ability

  def initialize(user)
        
    if !user
      can :request_group, Group
      can :create, Group
      can :pending_request, Group
    
    elsif user.admin?
      can :manage, :all
      
    elsif user.setup?
      can :setup, Group
      can :setup_password, User
      can :create_password, User
      can :setup_permalink, Group
      can :set_permalink, Group
    end
      
  end
end