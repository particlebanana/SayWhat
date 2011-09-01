class AdminUsersController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  before_filter :set_user, except: :index
  authorize_resource class: false
  
  respond_to :html
  
  # GET - View All Users
  def index
    @users = User.order('last_name ASC')
    respond_with(@users)
  end
  
  # GET - Edit A User Resource
  def edit
    respond_with(@user)
  end
  
  # PUT - Update A User Resource
  def update
    if @user.update_attributes(params[:user])
      redirect_to "/admin/users/#{@user.id}", notice: "User has been updated"
    else
      flash[:error] = "Error updating user"
      redirect_to "/admin/users/#{@user.id}"
    end
  end
  
  # DELETE - Delete A User Resource
  def destroy
    # Don't delete is user is a groups adult sponsor
    if @user.role == "adult sponsor"
      flash[:error] = "Must assign a new adult sponsor before you can delete this user"
      redirect_to "/admin/users/#{@user.id}"
    else
      if @user.destroy
        redirect_to "/admin/users", notice: "User has been deleted"
      else
        flash[:error] = "Error removing user"
        redirect_to "/admin/users/#{@user.id}"
      end
    end
  end
=begin  
  # GET - Remove an inappropriate avatar
  def remove_avatar
    @user.remove_avatar = true
    @user.avatar = nil
    @user.save
    redirect_to "/admin/users/#{@user.id}", :notice => "Avatar removed"
  end
=end  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
end
