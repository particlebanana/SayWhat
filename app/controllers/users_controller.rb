class UsersController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  before_filter :set_user
  load_and_authorize_resource
  
  respond_to :html
   
  # GET - Edit User
  def edit
    respond_with(@user)
  end
  
  # PUT - Update User
  def update
    if @user.update_attributes(params[:user])
      @user.recreate_object_key
      redirect_to "/settings", notice: "Profile has been updated"
    else
      render action: "edit"
    end
  end

  private
  
  def set_user
    @user = current_user
  end
end