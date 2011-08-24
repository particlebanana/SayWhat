class GroupsController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!, :except => [:request_group, :create, :pending_request, :index, :show, :request_membership, :create_membership_request, :membership_request_submitted]
  before_filter :find_by_permalink, :except => [:request_group, :create, :pending_request, :pending_groups, :index]
  before_filter :set_group, :only => [:pending_group, :approve_group, :deny_group]
    
  load_and_authorize_resource
  
  respond_to :html
    
  # GET - Group Index
  def index
    @groups = Group.order('created_at DESC').find_all{ |group| group.status == 'active'}
    respond_with(@groups)
  end
  
  # GET - Group Homepage
  def show
    @recent_projects = @group.projects.order('end_date DESC').find_all{ |project| project.end_date < Date.today}
    @adult_sponsor = @group.users.adult_sponsor.first
    @youth_sponsor = @group.users.youth_sponsor.first
    @members = @group.users.active.sort_by {rand}[0..19]
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
    @group.make_slug
    
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
      @group = Group.where(:permalink => params[:permalink]).first
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
  
end