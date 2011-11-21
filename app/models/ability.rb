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

      can :overview, Project
      can :index, Project
      can :show, Project

    # Site Admin
    elsif user.admin?
      can :manage, :all

    # Group Member
    elsif user.group_id
      can :edit, User, id: user.id
      can :update, User, id: user.id
      can :show, User

      can :index, Group
      can :show, Group

      can :overview, Project
      can :index, Project
      can :show, Project

      can :new, Project, group_id: user.group_id
      can :create, Project, group_id: user.group_id
      can :edit, Project, group_id: user.group_id
      can :update, Project, group_id: user.group_id

      can :create, ProjectPhoto, :project => { group_id: user.group_id }

      can :new, Grant, :project => { :group_id => user.group_id }
      can :create, Grant, :project => { :group_id => user.group_id }

      can :create, Comment

    # Registered User
    else
      can :edit, User, id: user.id
      can :update, User, id: user.id
      can :show, User

      can :create, Membership

      can :index, Group
      can :new, Group
      can :create, Group
      can :show, Group
      can :create_invite, Group
      can :send_invite, Group

      can :overview, Project
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

      can :destroy, ProjectPhoto, :project => { group_id: user.group_id }

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

      can :edit, Grant, :project => { :group_id => user.group_id }
      can :update, Grant, :project => { :group_id => user.group_id }

      can :new, Report, :project => { :group_id => user.group_id }
      can :create, Report, :project => { :group_id => user.group_id }

    # Group Youth Sponsor
    elsif user && user.youth_sponsor?

      can :destroy, Project, group_id: user.group_id

      can :edit, Group do |group|
        user.group == group
      end

      can :delete_photo, Group do |group|
        user.group == group
      end

      can :update, Group do |group|
        user.group == group
      end

      can :new, Report, :project => { :group_id => user.group_id }
      can :create, Report, :project => { :group_id => user.group_id }
    end

  end
end