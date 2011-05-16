class AdminController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  authorize_resource :class => false
  
  respond_to :html
  
  def index
  end
  
  #-----------------
  # REQUESTS
  #-----------------
  
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
  
  # Load group denied reasons from YAML file and return as json
  def denied_reasons
    @reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']
    render :layout => false
  end
  
  #-----------------
  # GRANTS
  #-----------------
  
  # GET - Display active grant applications
  def show_grants
    @grants = Grant.approved.desc('created_at')
    respond_with(@grants)
  end
  
  # GET - Display pending grant applications
  def show_pending_grants
    @grants = Grant.pending.desc('created_at')
    respond_with(@grants)
  end
  
  # GET - View single grant application
  def view_grant
    @grant = Grant.find(params[:id])
    respond_with(@grant)
  end
  
  # PUT - Approve a Mini-Grant
  def approve_grant
    @grant = Grant.find(params[:id])
    @grant.status = true
    if @grant.save
      UserMailer.send_grant_approval(@grant).deliver
      redirect_to "/admin/grants"
    else
      redirect_to "/admin/grants/#{@grant.id.to_s}", :notice => "Error saving record"
    end
  end
  
end
