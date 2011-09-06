class AdminGroupRequestsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  before_filter :set_group, except: [:index, :destroy]
  authorize_resource class: false
  
  respond_to :html
  
  # GET - Displays all pending group requests to a site admin
  def index
    @groups = Group.pending
    respond_with(@groups)
  end
  
  # GET - View a single group request
  def show
    @sponsor = @group.adult_sponsor
    respond_with(@group)
  end
 
  # PUT - Approve a group membership
  def update
    @sponsor = @group.adult_sponsor
    @sponsor.status = "active"
    @group.status = "active"
      
    if @group.save & @sponsor.save
      GroupMailer.send_approved_notice(@sponsor, @group, request.env["HTTP_HOST"]).deliver
      redirect_to "/admin/group_requests", notice: "Group was approved."
    else
      redirect_to "/admin/group_requests/#{@group.id.to_s}", alert: "Error approving group. Try again"
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
end