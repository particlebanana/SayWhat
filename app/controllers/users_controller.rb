class UsersController < ApplicationController
  layout "main"
  
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  respond_to :html
  
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
    @user.reset_authentication_token
    @user.update_with_password(params[:user])
    if @user.save!
      redirect_to "/setup/permalink"
    else
      render :action => 'setup_password'
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
      UserMailer.send_approved_notice(@user, @user.group, request.env["HTTP_HOST"]).deliver
      redirect_to "/groups/#{@user.group.permalink}/pending_memberships"
    else
      redirect_to "/groups/#{@user.group.permalink}/pending_memberships", :notice => "There was an error approving user"
    end
  end
  
  # GET - Setup Phase - New User Password Form
  def setup_member
    @user = current_user
    respond_with(@user)
  end
  
  # PUT - Setup Phase - Update Member Password
  def create_member
    @user.reset_authentication_token
    @user.update_with_password(params[:user])
    @user.status = "active"
    if @user.save
      redirect_to "/groups/#{@user.group.permalink}"
    else
      render :action => 'setup_member'
    end
  end
  
end
