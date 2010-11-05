class GroupsController < ApplicationController
  layout "main"
  
  
  before_filter :authenticate_user!, :except => [:request_group, :create, :pending_request]
  load_and_authorize_resource
  
  respond_to :html
  
  # GET
  # Request a new group
  def request_group
    @group = Group.new
    @user = User.new
    respond_with(@group)
  end
  
  # POST
  # Request a new group
  def create
    
    @group = Group.new(params[:group])
    @user = User.new(params[:group][:user])
    
    set_pending_attributes
    
    if @group.valid? & @user.valid?
      @group.users << @user
      @group.save!
      redirect_to pending_request_groups_url
    else
      render :action => 'request_group'
    end
  end
  
  # GET
  # Display Group request was successfully submitted
  def pending_request
    # TO DO
  end
  
  # GET
  # Displays all pending group requests to a site admin
  def pending_groups
    @groups = Group.find(:conditions => {:status => "pending"})
    respond_with(@groups)
  end
  
  # GET
  # Display a pending group's information to a site admin
  def pending_group
    @group = Group.find(params[:id])
    @user = @group.users.first
    respond_with(@group)
  end
  
  # PUT
  # Set a groups status to approved
  def approve_group
    @group = Group.find(params[:id])
    @user = @group.users.first
    @group.status = "active"
    @user.role = "adult sponsor"
    @user.status = "setup"
    if @group.update_attributes!(params[:group]) & @user.save
      redirect_to pending_groups_groups_path
    else
      render :action => 'pending_group'
    end
  end
  
  private 
  
    def set_pending_attributes
      @user.role = "pending"
      @user.status = "pending"
      @group.status = "pending"
    end
  
end