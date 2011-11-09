class AdminSponsorsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  before_filter :set_group
  authorize_resource class: false
  
  respond_to :html

  # GET - Pull a list of potential group members
  def index
    @members = @group.users.select {|u| ["youth sponsor", "member"].include?(u.role) && u.status == 'active' }
    render :layout => false
  end
  
  # PUT - Reassigns the adult sponsor
  def update
    return redirect_to "/admin/groups/#{@group.id}", alert: "Must select a valid user to be group sponsor" unless params[:user] && params[:user].length > 0
    @group.reassign_sponsor(params[:user])
    redirect_to "/admin/groups/#{@group.id}", notice: "Group sponsor updated!"
  end
  
  private
  
  def set_group
    @group = Group.find(params[:id])
  end
end