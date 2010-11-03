class GroupsController < ApplicationController
  layout "main"
  
  
  before_filter :authenticate_user!, :except => [:request_group, :create_request, :pending_request]
  load_and_authorize_resource
  
  respond_to :html
  
  # GET
  # Request a new group
  def request_group
    @group = Group.new
    respond_with(@group)
  end
  
  # POST
  # Request a new group
  def create_request
    @group = Group.new(params[:group])
    
    if @group.save
      redirect_to pending_request_groups_url
    else
      render :action => 'request_group'
    end
  end
  
  # GET
  # Display Group request was successfully submitted
  def pending_request
    
  end
  
end