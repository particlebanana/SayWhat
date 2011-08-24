class AdminGroupRequestsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  before_filter :set_group, :except => :index
  
  authorize_resource :class => false
  
  respond_to :html
  
  # GET - Displays all pending group requests to a site admin
  def index
    @groups = Group.pending
    respond_with(@groups)
  end
  
  # GET - View a single group request
  def show
    @sponsor = @group.users.first
    respond_with(@group)
  end
  
  # PUT - Approve a group membership
  def approve
    @user = @group.users.first 
    set_approved_attributes
      
    if @group.update_attributes(params[:group]) & @user.save
      GroupMailer.send_approved_notice(@user, @group, request.env["HTTP_HOST"]).deliver
      redirect_to "/admin/group_requests"
    else
      flash[:error] = "Error approving group!"
      redirect_to "/admin/group_requests/#{@group.id.to_s}"
    end
  end
  
  # Load group denied reasons from YAML file and return as json
  def destroy
    @reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['groups']
    render :layout => false
  end
  
  private
  
  def set_group
    @group = Group.find(params[:id])
  end
  
  def set_approved_attributes
    @group.status = "active"
    @user.role = "adult sponsor"
    @user.status = "active"
  end
end