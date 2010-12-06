class Ability
  include CanCan::Ability

  def initialize(user)
    
    # Not Logged In    
    if !user
      can :request_group, Group
      can :create, Group
      can :pending_request, Group
      can :show, Group
      can :request_membership, Group
      can :create_membership_request, Group
      can :membership_request_submitted, Group
    
    # Site Admin
    elsif user.admin?
      can :manage, :all
    
    # Sponsor in Setup Mode  
    elsif user.sponsor_setup?
      can :setup, Group
      can :setup_sponsor, User
      can :create_sponsor, User
      can :setup_permalink, Group
      can :set_permalink, Group
    
    # Member in Setup Mode  
    elsif user.member_setup?
      can :setup_member, User
      can :create_member, User
    
    # Registered User
    else
      can :edit, User
      can :update, User
      can :delete_avatar, User
      can :edit_password, User
      can :update_password, User
      
      can :show, Group
      can :create_invite, Group
      can :send_invite, Group
      
      can :index, Project
      can :new, Project
      can :create, Project
      can :show, Project
      
      can :new, Comment
      can :create, Comment
      can :edit, Comment
      can :update, Comment
      
      # TEMP FOR HOMEPAGE
      can :request_group, Group
    end
    
    # Sponsor
    if user && user.adult_sponsor?
      can :edit, Group
      can :update, Group
      can :pending_membership_requests, Group
      can :approve_pending_membership, User
      can :choose_youth_sponsor, User
      can :assign_youth_sponsor, User
      can :revoke_youth_sponsor, User
      can :edit, Project
      can :update, Project
      can :destroy, Comment
    
    elsif user && user.youth_sponsor?
      can :edit, Group
      can :update, Group
      can :edit, Project
      can :update, Project
      can :destroy, Comment
    end
      
  end
end