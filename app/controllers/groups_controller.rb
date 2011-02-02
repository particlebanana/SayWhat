class GroupsController < ApplicationController
  layout "main"
  
  before_filter :authenticate_user!, :except => [:home, :request_group, :create, :pending_request, :index, :show, :request_membership, :create_membership_request, :membership_request_submitted]
  before_filter :find_by_permalink, :except => [:request_group, :create, :pending_request, :pending_groups, :setup, :setup_permalink, :set_permalink, :index]
  before_filter :set_group, :only => [:pending_group, :approve_group]
    
  load_and_authorize_resource
  
  respond_to :html
  
  # GET - Home Page
  def home
    @projects = ProjectCache.desc(:end_date).find_all{ |project| project.end_date < Date.today}
    render :layout => "application"
  end
  
  # GET - Group Index
  def index
    @groups = Group.all.asc(:name)
    respond_with(@groups)
  end
  
  # GET - Group Homepage
  def show
    @recent_projects = @group.projects.desc(:end_date).find_all{ |project| project.end_date < Date.today}
    respond_with(@group)
  end
  
  # GET - Edit Screen
  def edit
    @adult_sponsor = @group.users.adult_sponsor.first
    @youth_sponsor = @group.users.youth_sponsor.first
    respond_with(@group)
  end
  
  # GET - Delete Profile Photo
  def delete_photo
    @group.remove_profile_photo!
    @group.profile_photo_filename = nil
    @group.save
    redirect_to "/groups/#{@group.permalink}/edit"
  end
  
  # PUT - Update Group
  def update
    if @group.update_attributes(params[:group])
      redirect_to "/groups/" + @group.permalink
    else
      render :action => "edit"
    end
  end
  
  ###############################################
  # REQUEST A GROUP BE CREATED
  ###############################################
  
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
      
      GroupMailer.successful_group_request(@user, @group).deliver
      
      admins = User.site_admins
      admins.each do |admin|
        GroupMailer.admin_pending_group_request(admin, @group, @user).deliver
      end
      
      redirect_to "/groups/pending"
    else
      render :action => 'request_group'
    end
  end
  
  # GET - Display Group request was successfully submitted
  def pending_request
  end
  
  ###############################################
  # APPROVE A GROUP'S CREATION
  ###############################################  
  
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
    @user = @group.users.first
    respond_with(@group)
  end
  
  
  # PUT - Set a groups status to approved
  def approve_group
    @user = @group.users.first 
    set_approved_attributes
      
    if @group.update_attributes(params[:group]) & @user.save
      GroupMailer.send_approved_notice(@user, @group, request.env["HTTP_HOST"]).deliver
      redirect_to "/groups/pending_groups"
    else
      render :action => 'pending_group'
    end
  end
  
  ###############################################
  # SETUP A GROUP
  ###############################################
  
  #
  # Allows a sponsor to setup basic settings for their group's page.
  # This function is only called once for each group.
  #  
  
  # GET - Setup Phase - Begin the setup process for a group
  def setup
    @group = Group.find(:first, :conditions => {:id => current_user.group_id})
    respond_with(@group)
  end
    
  # GET - Setup Phase - Group Permalink Form
  def setup_permalink
    @group = Group.find(:first, :conditions => {:id => current_user.group_id})
    respond_with(@group)
  end
  
  # PUT - Setup Phase - Create group permalink
  def set_permalink
    @group = Group.find(:first, :conditions => {:id => current_user.group_id})
    @group.permalink = params[:group][:permalink]
    @group.make_slug
    @user = current_user
    if @group.save
      @user.status = "active"
      if @user.save
        GroupMailer.send_completed_setup_notice(@user, @group, request.env["HTTP_HOST"]).deliver
        redirect_to "/groups/" + @group.permalink
      end
    else
      render :action => 'setup_permalink'
    end
  end
  
  ###############################################
  # REQUEST GROUP MEMBERSHIP
  ###############################################
  
  #
  # Allows anyone to request membership in a group or to be invited
  # into a group by a current member.
  #
  
  # GET - Invite Someone To Join
  def create_invite
    @user = User.new
    respond_with(@user)
  end
  
  # POST - Send An Email Invitation
  def send_invite
    @user = User.new(params[:user])
    GroupMailer.send_invite(@user, @group, request.env["HTTP_HOST"]).deliver
    redirect_to "/groups/#{@group.permalink}"
  end
  
  # GET - Request Membership
  def request_membership
    @user = User.new
    respond_with(@user)
  end
  
  # POST - Create Membership Request
  def create_membership_request
    @user = User.new(params[:user])
    
    set_membership_request_attributes
    
    if @user.valid?
      @group.users << @user
      @group.save!
      
      UserMailer.successful_membership_request(@user, @group).deliver
      
      adult_sponsor = @group.users.adult_sponsor.first
      UserMailer.sponsor_pending_membership_request(adult_sponsor, @group, @user).deliver
      
      # Create a new message and add it to the Adult Sponsor's inbox
      adult_sponsor.create_message_request_object(@user.name, @user.email, @user.id.to_s)
      
      redirect_to "/groups/#{@group.permalink}/request_submitted"
    else
      render :action => 'request_membership'
    end
  end
  
  # GET - Membership Request Successfull Submitted
  def membership_request_submitted  
  end
  
  
  private 
  
    def set_group
      @group = Group.find(params[:group_id])
    end
    
    def find_by_permalink
      @group = Group.find(:first, :conditions => {:permalink => params[:permalink]})
    end
  
    def set_pending_attributes
      @user.role = "pending"
      @user.status = "pending"
      @group.status = "pending"
    end
    
    def set_membership_request_attributes
      @user.role = "pending"
      @user.status = "pending"
    end
    
    def set_approved_attributes
      @group.status = "active"
      @user.role = "adult sponsor"
      @user.status = "setup"
    end
  
end