class Ability
  include CanCan::Ability

  def initialize(user)
    
    # Not Logged In    
    if !user
      can :home, Group
      
      can :request_group, Group
      can :create, Group
      can :pending_request, Group
      can :index, Group
      can :show, Group
      can :request_membership, Group
      can :create_membership_request, Group
      can :membership_request_submitted, Group
      can :all, Project
      can :index, Project
      can :filter, Project
      can :show, Project
    
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
      
      can :index, Message
      can :show, Message
      can :destroy, Message
      
      can :index, Group
      can :show, Group
      can :create_invite, Group
      can :send_invite, Group
      
      can :all, Project
      can :filter, Project
      can :index, Project
      
      can :new, Project do |project|
        user.group_id == project.group_id
      end
      
      can :create, Project do |project|
        user.group.id.to_s == project.group_id
      end
      
      can :show, Project
      
      can :new, Comment
      can :create, Comment
      can :edit, Comment
      can :update, Comment
      
      # TEMP FOR HOMEPAGE
      can :home, Group
    end
    
    # Adult Sponsor
    if user && user.adult_sponsor?
      
      # Memberships Controller
      can :approve_pending_group_member, User
      can :deny_pending_group_member, User
      
      # Youth Sponsors Controller
      can :view_potential_sponsors, User
      can :update_youth_sponsor, User
      can :destroy_youth_sponsor, User
      
      can :create, Message
      
      can :edit, Group do |group|
        user.group == group
      end
      
      can :delete_photo, Group do |group|
        user.group == group
      end
      
      can :update, Group do |group|
        user.group == group
      end
      
      can :pending_membership_requests, Group do |group|
        user.group == group
      end
            
      can :edit, Project do |project|
        user.group == project.group
      end
      
      can :delete_photo, Project do |project|
        user.group == project.group
      end
      
      can :update, Project do |project|
        user.group == project.group
      end
      
      can :destroy, Comment do |comment|
        user.group == comment.project.group
      end
      
      can :new, Report do |report|
        project = Project.find(report.project_id)
        user.group == project.group
      end
      
      can :create, Report do |report|
        project = Project.find(report.project_id)
        user.group == project.group
      end
    
    # Youth Sponsor
    elsif user && user.youth_sponsor?
      
      can :create, Message
      
      can :edit, Group do |group|
        user.group == group
      end
      
      can :delete_photo, Group do |group|
        user.group == group
      end
      
      can :update, Group do |group|
        user.group == group
      end
      
      can :edit, Project do |project|
        user.group == project.group
      end
      
      can :delete_photo, Project do |project|
        user.group == project.group
      end
      
      can :update, Project do |project|
        user.group == project.group
      end
      
      can :destroy, Comment do |comment|
        user.group == comment.project.group
      end
      
      can :new, Report do |report|
        project = Project.find(report.project_id)
        user.group == project.group
      end
      
      can :create, Report do |report|
        project = Project.find(report.project_id)
        user.group == project.group
      end
      
    end
      
  end
end