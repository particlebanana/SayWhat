class UsersController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  before_filter :set_current_user, except: [:show]
  before_filter :set_user_from_param, only: [:show]
  load_and_authorize_resource
  
  respond_to :html

  # GET - Show User Profile
  def show
    respond_with(@user)
  end
   
  # GET - Edit User
  def edit
    respond_with(@user)
  end
  
  # PUT - Update User
  def update
    if @user.update_attributes(params[:user])
      if params[:group_id] && @user.group == nil
        @user.join_group(params[:group_id])
        redirect_to group_path(@user.group.permalink)
      else
        @user.recreate_object_key
        redirect_to "/settings", notice: "Profile has been updated"
      end
    else
      render action: "edit"
    end
  end

  private
  
  def set_current_user
    @user = current_user
  end

  def set_user_from_param
    @user = User.find(params[:id])
  end
end