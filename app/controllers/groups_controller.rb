class GroupsController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :set_group, except: [:index, :new, :create]
  load_and_authorize_resource
  
  respond_to :html
    
  # GET - Group Index
  def index
    @groups = Group.where(status: 'active').order('created_at DESC')
    respond_with(@groups)
  end
  
  # GET - Show indivudal group info
  def show
    @timeline = Hashie::Mash.new($feed.timeline("group:#{@group.id}"))
    @projects = @group.projects.order('updated_at DESC').limit(3)
    @pending_membership = set_pending_membership
    respond_with(@group)
  end
  
  # GET - Edit group
  # ONLY Adult Sponsor, Youth Sponsor
  def edit
    respond_with(@group)
  end
  
  # PUT - Update group
  # ONLY Adult Sponsor, Youth Sponsor
  def update
    if @group.update_attributes(params[:group])
      redirect_to group_path(id: @group.permalink), notice: "Group has been updated successfully."
    else
      render action: "edit"
    end
  end
  
  # GET - Request a new group
  def new
    @group = Group.new
    respond_with(@group)
  end
  
  # POST - Create a new group
  # Group status is set to 'pending' by default
  # Must be approved by site admin before active
  def create
    @group = Group.new(params[:group])
    if @group.initialize_pending(current_user)
      redirect_to groups_path, notice: 'Group has been submitted for approval.'
    else
      render action: 'new'
    end
  end
  
  private 
  
  def set_group
    @group = Group.where(:permalink => params[:id]).first
  end

  def set_pending_membership
    if current_user
      Membership.where(user_id: current_user.id).first.nil? ? false : true
    else
      false
    end
  end
end