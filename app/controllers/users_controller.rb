class UsersController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  respond_to :html

  ################################
  # Admin Panel
  ################################
  
  # GET - Admin Panel
  def admin_panel

  end
  
  # GET - Manage Mini-Grants
  def manage_grants
    @pending = Grant.pending.desc('created_at')
    @approved = Grant.approved.desc('created_at')
  end
  
  # GET - View A Grant Application
  def view_grant
    @grant = Grant.find(params[:grant_id])
    render :layout => "form"
  end
  
  # PUT - Approve A Grant
  def approve_grant
    @grant = Grant.find(params[:grant_id])
    @grant.status = true
    if @grant.save
      UserMailer.send_grant_approval(@grant).deliver
      redirect_to "/admin/manage_grants"
    else
      redirect_to "/admin/manage_grants", :notice => "Error saving record"
    end
  end
    
  ################################
  # Setup A Sponsor Account
  ################################
  
  # GET - Setup Phase - New User Password Form
  def setup_sponsor
    @user = current_user
    respond_with(@user)
  end
  
  # PUT - Setup Phase - Update Sponsor Password
  def create_sponsor
    if params[:user][:password] != "" && params[:user][:password_confirmation] != ""
      if params[:user][:password] == params[:user][:password_confirmation]
        @user.reset_authentication_token
        @user.update_with_password(params[:user])
        if @user.save!
          redirect_to "/setup/permalink"
        else
          redirect_to "/setup/sponsor", :notice => "You Must Set A Password"
        end
      else
        redirect_to "/setup/sponsor", :notice => "You Must Set A Password"
      end
    else
      redirect_to "/setup/sponsor", :notice => "You Must Set A Password"
    end
  end
  
  ###############################################
  # Edit user settings (profile, password, etc)
  ###############################################
  
  # GET - Edit Basic Profile Information
  def edit
    @user = current_user
    respond_with(@user)
  end
  
  # PUT - Update Basic Profile Information
  def update
    if @user.update_attributes(params[:user])
      redirect_to "/settings/profile", :notice => "Profile has been updated"
    else
      render :action => "edit"
    end
  end
  
  # GET - Delete Avatar
  def delete_avatar
    @user.remove_avatar!
    @user.avatar_filename = nil
    @user.save
    redirect_to "/settings/profile"
  end
  
  # GET - Edit User Password
  def edit_password
    @user = current_user
    respond_with(@user)
  end
  
  # PUT - Update User Password
  def update_password
    if @user.update_attributes(params[:user])
      redirect_to "/settings/password", :notice => "Password has been updated"
    else
      render :action => "edit_password"
    end
  end
  
  
  ###############################################
  # Assign A Student Sponsor
  ###############################################
  
  #
  # Allow a group adult sponsor to assign a student sponsor to help manage the group.
  # Has similar but not identical permissions to the adult sponsor.
  #
  
  # GET - Choose a youth sponsor from group members
  def choose_youth_sponsor
    @user = current_user
    @members = @user.group.users.active.members
    respond_with(@members)
  end
  
  # GET - Assigns a group member the role of student sponsor
  def assign_youth_sponsor
    @user = User.find(params[:user_id])
    @user.role = "youth sponsor"
    if @user.save
      UserMailer.send_sponsor_promotion(@user, @user.group).deliver
      redirect_to "/groups/#{@user.group.permalink}/edit"
    else
      redirect_to "/groups/#{@user.group.permalink}/edit", :notice => "Error assigning youth sponsor"
    end
  end
  
  # GET - Remove a group member from the role of student sponsor
  def revoke_youth_sponsor
    @user = User.find(params[:user_id])
    @user.role = "member"
    if @user.save
      UserMailer.send_sponsor_revocation(@user, @user.group).deliver
      redirect_to "/groups/#{@user.group.permalink}/edit"
    else
      redirect_to "/groups/#{@user.group.permalink}/edit", :notice => "Error removing youth sponsor"
    end
  end
  
  ###############################################
  # Approve Group Membership Request
  ###############################################
  
  #
  # Only a group sponsor can approve a potential member for
  # inclusion into a group, even if that member was invited.
  #
    
  # GET - Approve Pending Group Member
  def approve_pending_membership
    @user.status = "setup"
    @user.role = "member"
    if @user.save
      message = current_user.messages.find(params[:message])
      message.delete
      UserMailer.send_approved_notice(@user, @user.group, request.env["HTTP_HOST"]).deliver
      redirect_to "/messages", :notice => "Member has been added"
    else
      redirect_to "/messages", :notice => "There was an error approving user"
    end
  end
  
  # GET - Deny Pending Group Member
  def deny_pending_membership
    message = current_user.messages.find(params[:message])
    message.delete
    @user.delete
    redirect_to "/messages", :notice => "Member has been removed"
  end
  
  # GET - Setup Phase - New User Password Form
  def setup_member
    @user = current_user
    respond_with(@user)
  end
  
  # PUT - Setup Phase - Update Member Password
  def create_member
    if params[:user][:password] != "" && params[:user][:password_confirmation] != ""
      if params[:user][:password] == params[:user][:password_confirmation]
        @user.reset_authentication_token
        @user.update_with_password(params[:user])
        @user.status = "active"
        if @user.save
          redirect_to "/groups/#{@user.group.permalink}"
        else
          render :action => 'setup_member'
        end
      else
        render :action => 'setup_member'
      end
    else
      render :action => 'setup_member'
    end
  end
  
end
