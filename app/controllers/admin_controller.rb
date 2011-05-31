class AdminController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  authorize_resource :class => false
  
  respond_to :html
  
  # Overview Dashboard page
  def index
    @group_requests = Group.where(:status => "pending").count
    @grant_requests = Grant.pending.count
    @groups = Group.where(:status => "active").count
    @projects = ProjectCache.count
  end
  
  #-----------------
  # REQUESTS
  #-----------------
  
  # GET - Displays all pending group requests to a site admin
  def show_requests
    @groups = Group.where(:status => "pending").all
    respond_with(@groups)
  end
  
  # GET - View a single group request
  def view_request
    @group = Group.find(params[:id])
    @sponsor = @group.users.first
    respond_with(@group)
  end
  
  # Load group denied reasons from YAML file and return as json
  def denied_group_reasons
    @reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['groups']
    render :layout => false
  end
  
  #-----------------
  # GRANTS
  #-----------------
  # 
  # Unlike the group requests mini-grant applications are handled
  # through an embedded sinatra app. Because of that the approve and deny
  # logic must be included in the admin actions.
  #
  
  # GET - Display active grant applications
  def show_grants
    @grants = Grant.approved.desc('created_at')
    respond_with(@grants)
  end
  
  # GET - Display pending grant applications
  def show_pending_grants
    @grants = Grant.pending.desc('created_at')
    respond_with(@grants)
  end
  
  # GET - View single grant application
  def view_grant
    @grant = Grant.find(params[:id])
    respond_with(@grant)
  end
  
  # PUT - Approve a Mini-Grant
  def approve_grant
    @grant = Grant.find(params[:id])
    @grant.status = true
    if @grant.save
      UserMailer.send_grant_approval(@grant).deliver
      redirect_to "/admin/grants"
    else
      redirect_to "/admin/grants/#{@grant.id.to_s}", :notice => "Error saving record"
    end
  end
  
  # Load grant denied reasons from YAML file and return as json
  def denied_grant_reasons
    @reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['grants']
    render :layout => false
  end
  
  # POST - Deny a Mini-Grant
  def deny_grant
    if params[:reason] && params[:reason] != "" # require a reason
      @grant = Grant.find(params[:id])
      reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['grants']
      reason = reasons.select{|r| r['name'] == params[:reason]}[0]
      if @grant.destroy
        UserMailer.send_grant_denied(@grant, reason['email_text']).deliver
        redirect_to "/admin/grants/pending", :notice => "Grant application has been removed" 
      else
        flash[:error] = "Error removing grant application from the system"
        redirect_to "/admin/grants/#{@grant.id.to_s}"
      end
    else
      flash[:error] = "Error removing grant application from the system"
      redirect_to "/admin/grants/#{params[:id]}"
    end
  end
  
  #-----------------
  # GROUPS
  #-----------------
  
  # GET - View All Groups
  def show_groups
    @groups = Group.asc('name')
  end
  
  # GET - View single group
  def view_group
    @group = Group.find(params[:id])
    @sponsor = @group.status == 'pending' ? @group.users.first : @group.users.adult_sponsor.first
  end
  
  # PUT - Update a groups basic settings
  def update_group
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      redirect_to "/admin/groups", :notice => "Record updated successfully"
    else
      flash[:error] = "Problem updating record"
      redirect_to "/admin/groups/#{@group.id.to_s}"
    end
  end
  
  # GET - Pull a list of potential group members
  def choose_sponsor
    group = Group.find(params[:id])
    @members = group.users.select {|u| ["youth sponsor", "member"].include?(u.role) && u.status == 'active' }
    render :layout => false
  end
  
  # PUT - Reassigns the adult sponsor
  def reassign_sponsor
    group = Group.find(params[:id])
    if params[:user] && !params[:user].empty?
      group.reassign_sponsor(params[:user])
      redirect_to "/admin/groups/#{group.id.to_s}", :notice => "Group sponsor updated!"
    else
      flash[:error] = "Must select a valid user to be group sponsor"
      redirect_to "/admin/groups/#{group.id.to_s}"
    end
  end
  
  # PUT - Resend a group approval email
  def group_approval_email
    group = Group.find(params[:id])
    if group.status == 'setup'
      user = group.users.first 
      GroupMailer.send_approved_notice(user, group, request.env["HTTP_HOST"]).deliver
      flash[:notice] = "Approval email has been sent"
      redirect_to "/admin/groups/#{group.id.to_s}"
    else
      flash[:notice] = "Group must be in setup state to re-send approval email"
      redirect_to "/admin/groups/#{group.id.to_s}"
    end
  end
  
  #-----------------
  # USERS
  #-----------------
  
  # GET - View all registered users
  def show_users
    @users = User.asc(:last_name)
  end
  
  # GET - View single user
  def view_user
    @user = User.find(params[:id])
  end
  
  # GET - Remove an inappropriate avatar
  def remove_avatar
    @user = User.find(params[:id])
    @user.remove_avatar!
    @user.avatar_filename = nil
    @user.save
    redirect_to "/admin/users/#{@user.id}", :notice => "Avatar removed"
  end
  
  # PUT - Update a user
  def update_user
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to "/admin/users/#{@user.id.to_s}", :notice => "User has been updated"
    else
      flash[:error] = "Error updating user"
      redirect_to "/admin/users/#{@user.id.to_s}"
    end
  end
  
  # DELETE - Delete a user
  def destroy_user
    @user = User.find(params[:id])
    # Don't delete is user is a groups adult sponsor
    if @user.role == "adult sponsor"
      flash[:error] = "Must assign a new adult sponsor before you can delete this user"
      redirect_to "/admin/users/#{@user.id.to_s}"
    else
      if @user.destroy
        redirect_to "/admin/users", :notice => "User has been deleted"
      else
        flash[:error] = "Error removing user"
        redirect_to "/admin/users/#{@user.id.to_s}"
      end
    end
  end
  
end
