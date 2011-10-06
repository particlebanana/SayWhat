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
      can :edit, User, id: user.id
      can :update, User, id: user.id
      
      can :index, Group
      can :show, Group

      can :new, Project, group_id: user.group_id
      can :create, Project, group_id: user.group_id
      can :edit, Project, group_id: user.group_id
      can :update, Project, group_id: user.group_id
      
      can :create, Comment
    
    # Registered User
    else
      can :edit, User, id: user.id
      can :update, User, id: user.id
      
      can :create, Membership

      can :index, Group
      can :new, Group
      can :create, Group
      can :show, Group
      can :create_invite, Group
      can :send_invite, Group
      
      can :index, Project
      can :show, Project
      
      can :create, Comment

      # TEMP FOR HOMEPAGE
      can :home, Group
    end
    
    # Group Adult Sponsor
    if user && user.adult_sponsor?
      
      can :update, Membership, group_id: user.group_id
      can :destroy, Membership, group_id: user.group_id
      
      # Youth Sponsors Controller
      can :view_potential_sponsors, User
      can :update_youth_sponsor, User
      can :destroy_youth_sponsor, User
      
      can :destroy, Project, group_id: user.group_id
      
      can :destroy, ProjectComment do |comment|
        user.group == comment.project.group
      end

      can :destroy, GroupComment do |comment|
        user.group == comment.group
      end
      
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
      
      can :destroy, ProjectComment do |comment|
        user.group == comment.project.group
      end

      can :destroy, GroupComment do |comment|
        user.group == comment.group
      end
      
      can :edit, Group do |group|
        user.group == group
      end
      
      can :delete_photo, Group do |group|
        user.group == group
      end
      
      can :update, Group do |group|
        user.group == group
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