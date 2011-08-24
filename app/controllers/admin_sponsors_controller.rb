class AdminSponsorsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  before_filter :set_group
  
  authorize_resource :class => false
  
  respond_to :html

  # GET - Pull a list of potential group members
  def index
    @members = @group.users.select {|u| ["youth sponsor", "member"].include?(u.role) && u.status == 'active' }
    render :layout => false
  end
  
  # PUT - Reassigns the adult sponsor
  def update
    if params[:user] && !params[:user].empty?
      @group.reassign_sponsor(params[:user])
      redirect_to "/admin/groups/#{@group.id.to_s}", :notice => "Group sponsor updated!"
    else
      flash[:error] = "Must select a valid user to be group sponsor"
      redirect_to "/admin/groups/#{group.id.to_s}"
    end
  end
  
  private
  
  def set_group
    @group = Group.find(params[:id])
  end
end