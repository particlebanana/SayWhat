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
      redirect_to "/settings/profile", notice: "Profile has been updated"
    else
      render action: "edit", alert: "Error updating profile. Try again."
    end
  end

  private
  
  def set_user
    @user = current_user
  end
end