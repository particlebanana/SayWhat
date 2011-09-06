class UsersController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  respond_to :html
  
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
    @user.status = "active"
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
    
end
