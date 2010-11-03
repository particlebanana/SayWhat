class Ability
  include CanCan::Ability

  def initialize(current_user)
    
    if !current_user
      can :request_group, Group
      can :create_request, Group
      can :pending_request, Group
    end
      
  end
end