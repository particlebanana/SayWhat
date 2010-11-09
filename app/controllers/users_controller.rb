class UsersController < ApplicationController
  layout "main"
  
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  respond_to :html
  
  # GET - Setup Phase - New User Password Form
  def setup_password
    @user = current_user
    respond_with(@user)
  end
  
  # PUT - Setup Phase - Update Password
  def create_password
    @user.update_with_password(params[:user])
    if @user.save!
      redirect_to "/setup/permalink"
    else
      render :action => 'setup_password'
    end
  end
  
end
