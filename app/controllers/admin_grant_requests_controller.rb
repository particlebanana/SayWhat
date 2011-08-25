class AdminGrantRequestsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  
  authorize_resource :class => false
  
  respond_to :html
  
  # GET - All Pending Grants
  def index
    @grants = Grant.pending.order('created_at DESC')
    respond_with(@grants)
  end
  
  # GET - Edit A Grant Application
  def edit
    @grant = Grant.find(params[:id])
    respond_with(@grant)
  end
  
  # PUT - Approve a Grant Application
  def update
    @grant = Grant.find(params[:id])
    @grant.status = true
    if @grant.save
      UserMailer.send_grant_approval(@grant).deliver
      redirect_to "/admin/grants"
    else
      redirect_to "/admin/grants/#{@grant.id.to_s}/edit", :notice => "Error saving record"
    end
  end
  
  # Load grant denied reasons from YAML file and return as json
  def destroy
    @reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['grants']
    render :layout => false
  end
  
end