class Ability
  include CanCan::Ability

  def initialize(user)
        
    if !user
      can :request_group, Group
      can :create, Group
      can :pending_request, Group
      can :show, Group
    
    elsif user.admin?
      can :manage, :all
      
    elsif user.setup?
      can :setup, Group
      can :setup_sponsor, User
      can :create_sponsor, User
      can :setup_permalink, Group
      can :set_permalink, Group
      
      # TEMP FOR HOMEPAGE
      can :request_group, Group
    
    else
      can :show, Group
      can :edit, Group
      can :update, Group
      
      # TEMP FOR HOMEPAGE
      can :request_group, Group
    end
      
  end
end