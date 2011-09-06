class AdminGrantRequestsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  before_filter :set_grant, except: :index
  authorize_resource class: false
  
  respond_to :html
  
  # GET - All Pending Grants
  def index
    @grants = Grant.pending.order('created_at DESC')
    respond_with(@grants)
  end
  
  # GET - Edit A Grant Application
  def edit
    respond_with(@grant)
  end
  
  # PUT - Approve a Grant Application
  def update
    if @grant.approve
      redirect_to "/admin/grants", notice: "Grant was approved"
    else
      redirect_to "/admin/grants/#{@grant.id.to_s}/edit", alert: "Error saving record"
    end
  end
 
  # Load grant denied reasons from YAML file and return as json
  def destroy
    @reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['grants']
    render :layout => false
  end

  private
  
  def set_grant
    @grant = Grant.find(params[:id])
  end
end