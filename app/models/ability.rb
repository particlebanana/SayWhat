class Ability
  include CanCan::Ability

  def initialize(user)
    
    # Not Logged In    
    if !user
      can :home, Group
      
      can :index, Group
      can :show, Group
      can :create, Group
      can :new, Group

      can :index, Project
      can :show, Project
    
    # Site Admin
    elsif user.admin?
      can :manage, :all
    
    # Group Member
    elsif user.group_id
      can :new, Project, group_id: user.group_id
      can :create, Project, group_id: user.group_id
      can :edit, Project, group_id: user.group_id
      can :update, Project, group_id: user.group_id
    
    # Registered User
    else
      can :edit, User
      can :update, User
      #can :delete_avatar, User
      #can :edit_password, User
      #can :update_password, User
      
      can :index, Message
      can :show, Message
      can :destroy, Message
      
      can :create_pending_group_request, Message
      
      can :index, Group
      can :new, Group
      can :create, Group
      can :show, Group
      can :create_invite, Group
      can :send_invite, Group
      
      can :index, Project
      can :show, Project
      #can :all, Project
      #can :filter, Project
      #can :index, Project
      
      #can :new, Project do |project|
        
      #end
       
      #can :create, Project do |project|
      #  user.group.id.to_s == project.group_id
      #end
      
      #can :show, Project
      
      can :new, Comment
      can :create, Comment
      can :edit, Comment
      can :update, Comment
      
      # TEMP FOR HOMEPAGE
      can :home, Group
    end
    
    # Group Adult Sponsor
    if user && user.adult_sponsor?
      
      # Memberships Controller
      can :approve_pending_group_member, User
      can :deny_pending_group_member, User
      
      # Youth Sponsors Controller
      can :view_potential_sponsors, User
      can :update_youth_sponsor, User
      can :destroy_youth_sponsor, User
      
      can :destroy, Project, group_id: user.group_id
      
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
    
    # Group Youth Sponsor
    elsif user && user.youth_sponsor?
      
      can :destroy, Project, group_id: user.group_id
      
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