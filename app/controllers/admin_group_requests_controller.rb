class AdminGroupRequestsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  before_filter :set_group, except: :index
  authorize_resource class: false
  
  respond_to :html
  
  # GET - Displays all pending group requests to a site admin
  def index
    @groups = Group.pending
    respond_with(@groups)
  end
  
  # GET - View a single group request
  def show
    @reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['groups']
    respond_with(@group)
  end
 
  # PUT - Approve a group membership
  def update
    if @group.update_attributes(params[:group])
      if @group.approve(request.env["HTTP_HOST"])
        redirect_to "/admin/group_requests", notice: "Group was approved."
      else
        redirect_to "/admin/group_requests/#{@group.id.to_s}", alert: "Error approving group. Try again"
      end
    else
      redirect_to "/admin/group_requests/#{@group.id.to_s}", alert: "Error approving group. Try again"
    end
  end
  
  private
  
  def set_group
    @group = Group.find(params[:id])
  end
end