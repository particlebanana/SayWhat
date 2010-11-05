class GroupsController < ApplicationController
  layout "main"
  
  
  before_filter :authenticate_user!, :except => [:request_group, :create, :pending_request]
  load_and_authorize_resource
  
  respond_to :html
  
  #
  # REQUEST A GROUP BE CREATED
  #
  
  #
  # Allows anyone to request a group to be created for their organization.
  # Groups must be approved by an admin to actually be active.
  # Also creates a user account to embed in a group instance that will administer
  # the group.
  #
  
  # GET - Request a new group
  def request_group
    @group = Group.new
    @user = User.new
    respond_with(@group)
  end
  
  
  # POST - Request a new group
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
  
  
  # GET - Display Group request was successfully submitted
  def pending_request
    # TO DO
  end
  

  #
  # APPROVE A GROUP'S CREATION
  #
  
  #  
  # Admin functions to approve a pending group.
  # Once approved an email should be sent to the group sponsor
  # This email should contain a link with a login token that will
  # allow the sponsor to set a password and to set-up the group
  #
  
  # GET - Displays all pending group requests to a site admin
  def pending_groups
    @groups = Group.find(:conditions => {:status => "pending"})
    respond_with(@groups)
  end
  
  
  # GET - Display a pending group's information to a site admin
  def pending_group
    @group = Group.find(params[:id])
    @user = @group.users.first
    respond_with(@group)
  end
  
  
  # PUT - Set a groups status to approved
  def approve_group
    @group = Group.find(params[:id])
    @user = @group.users.first
    
    set_approved_attributes
    
    if @group.update_attributes!(params[:group]) & @user.save
      redirect_to pending_groups_groups_path
    else
      render :action => 'pending_group'
    end
  end
  
  
  #
  # SETUP A GROUP
  #
  
  #
  # Allows a sponsor to setup basic settings for their group's page.
  # This function is only called once for each group.
  #  
  
  
  # PENDING
  
  private 
  
    def set_pending_attributes
      @user.role = "pending"
      @user.status = "pending"
      @group.status = "pending"
    end
    
    def set_approved_attributes
      @group.status = "active"
      @user.role = "adult sponsor"
      @user.status = "setup"
    end
  
end