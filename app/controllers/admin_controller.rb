class AdminController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  authorize_resource :class => false
  
  respond_to :html
  
  def index
  end
  
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
  
end
