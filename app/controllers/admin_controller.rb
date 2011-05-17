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
  def denied_group_reasons
    @reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['groups']
    render :layout => false
  end
  
  #-----------------
  # GRANTS
  #-----------------
  # 
  # Unlike the group requests mini-grant applications are handled
  # through an embedded sinatra app. Because of that the approve and deny
  # logic must be included in the admin actions.
  #
  
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
  
  # Load grant denied reasons from YAML file and return as json
  def denied_grant_reasons
    @reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['grants']
    render :layout => false
  end
  
  # POST - Deny a Mini-Grant
  def deny_grant
    if params[:reason] && params[:reason] != "" # require a reason
      @grant = Grant.find(params[:id])
      reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['grants']
      reason = reasons.select{|r| r['name'] == params[:reason]}[0]
      if @grant.destroy
        UserMailer.send_grant_denied(@grant, reason['email_text']).deliver
        redirect_to "/admin/grants/pending", :notice => "Grant application has been removed" 
      else
        redirect_to "/admin/grants/#{@grant.id.to_s}", :error => "Error removing grant application from the system"
      end
    else
      redirect_to "/admin/grants/#{params[:id]}", :error => "Error removing grant application from the system"
    end
  end
  
end
