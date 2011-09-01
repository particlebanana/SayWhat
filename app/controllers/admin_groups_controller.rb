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
    # require a reason
    return redirect_to "/admin/group_requests/#{@group.id}", alert: "Error removing group" unless params[:reason] && params[:reason].length > 0
    reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['groups']
    reason = reasons.select{|r| r['name'] == params[:reason]}[0]
    if @group.deny(reason)
      redirect_to "/admin/group_requests", notice: "Group and Sponsor successfully removed"
    else
      redirect_to "/admin/group_requests/#{@group.id}", alert: "Error removing group!"
    end
  end
  
  private
  
  def set_group
    @group = Group.find(params[:id])
  end
end
