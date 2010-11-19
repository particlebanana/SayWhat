class UsersController < ApplicationController
  layout "main"
  
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  respond_to :html
  
  # GET - Setup Phase - New User Password Form
  def setup_sponsor
    @user = current_user
    respond_with(@user)
  end
  
  # PUT - Setup Phase - Update Sponsor Password and Username
  def create_sponsor
    @user.reset_authentication_token
    @user.update_with_password(params[:user])
    if @user.save!
      redirect_to "/setup/permalink"
    else
      render :action => 'setup_password'
    end
  end
  
  # GET - Edit Basic Profile Information
  def edit
    @user = current_user
    respond_with(@user)
  end
  
  # PUT - Update Basic Profile Information
  def update
    if @user.update_attributes(params[:user])
      redirect_to "/settings/profile", :notice => "Profile Has Been Updated"
    else
      render :action => "edit"
    end
  end
  
end
