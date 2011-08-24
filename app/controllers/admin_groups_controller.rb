class AdminGroupsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  before_filter :set_group, :except => :index
  
  authorize_resource :class => false
  
  respond_to :html
  
  # GET - View All Groups
  def index
    @groups = Group.order('name ASC')
    respond_with(@groups)
  end
  
  # GET - View single group
  def show
    @sponsor = @group.status == 'pending' ? @group.users.first : @group.users.adult_sponsor.first
  end
  
  # PUT - Update a groups basic settings
  def update
    if @group.update_attributes(params[:group])
      redirect_to "/admin/groups", :notice => "Record updated successfully"
    else
      flash[:error] = "Problem updating record"
      redirect_to "/admin/groups/#{@group.id.to_s}"
    end
  end
  
  # DELETE - Deny a group membership
  def destroy
    if params[:reason] && params[:reason] != "" # require a reason
      @user = @group.users.first # There is only a single user at this point (adult sponsor)
      reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['groups']
      reason = reasons.select{|r| r['name'] == params[:reason]}[0]
      if @group.destroy
        GroupMailer.send_denied_notice(@user, @group, reason['email_text']).deliver
        @user.destroy
        flash[:notice] = "Group and Sponsor successfully removed" 
        redirect_to "/admin/group_requests"
      else
        flash[:error] = "Error removing group!"
        redirect_to "/admin/group_requests/#{@group.id}"
      end
    else
      flash[:error] = "Error removing group!"
      redirect_to "/admin/group_requests/#{@group.id}"
    end
  end
  
  # POST - Resend a group approval email
  def resend
    if @group.status == 'setup'
      @user = @group.users.first 
      GroupMailer.send_approved_notice(@user, @group, request.env["HTTP_HOST"]).deliver
      flash[:notice] = "Approval email has been sent"
      redirect_to "/admin/groups/#{@group.id.to_s}"
    else
      flash[:notice] = "Group must be in setup state to re-send approval email"
      redirect_to "/admin/groups/#{@group.id.to_s}"
    end
  end
  
  private
  
  def set_group
    @group = Group.find(params[:id])
  end
end
