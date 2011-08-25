class AdminGrantsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  
  authorize_resource :class => false
  
  respond_to :html
  
  # GET - All Rewarded Grants
  def index
    @grants = Grant.approved.order('created_at DESC')
    respond_with(@grants)
  end
  
  # GET - View A Single Rewarded Grant
  def show
    @grant = Grant.find(params[:id])
    respond_with(@grant)
  end
    
  # DELETE - Deny a Mini-Grant
  def destroy
    if params[:reason] && params[:reason] != "" # require a reason
      @grant = Grant.find(params[:id])
      reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['grants']
      reason = reasons.select{|r| r['name'] == params[:reason]}[0]
      if @grant.destroy
        UserMailer.send_grant_denied(@grant, reason['email_text']).deliver
        redirect_to "/admin/grants/pending", :notice => "Grant application has been removed" 
      else
        flash[:error] = "Error removing grant application from the system"
        redirect_to "/admin/grants/#{@grant.id.to_s}/edit"
      end
    else
      flash[:error] = "Error removing grant application from the system"
      redirect_to "/admin/grants/#{params[:id]}/edit"
    end
  end
end
