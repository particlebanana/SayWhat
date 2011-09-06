class AdminGrantsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  before_filter :set_grant, except: :index
  authorize_resource class: false
  
  respond_to :html
  
  # GET - All Rewarded Grants
  def index
    @grants = Grant.approved.order('created_at DESC')
    respond_with(@grants)
  end
 
  # GET - View A Single Rewarded Grant
  def show
    respond_with(@grant)
  end
    
  # DELETE - Deny a Mini-Grant
  def destroy
    # require a reason
    return redirect_to "/admin/grants/#{@grant.id.to_s}", alert: "Error denying grant" unless params[:reason] && params[:reason].length > 0
    reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['grants']
    reason = reasons.select{|r| r['name'] == params[:reason]}[0]
    if @grant.deny(reason)
      redirect_to "/admin/grants/pending", notice: "Grant application has been removed" 
    else
      redirect_to "/admin/grants/#{@grant.id.to_s}/edit", alert: "Error removing grant application from the system"
    end
  end
  
  private
  
  def set_grant
    @grant = Grant.find(params[:id])
  end
end
