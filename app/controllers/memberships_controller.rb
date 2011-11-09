class MembershipsController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  before_filter :set_membership, except: :create
  before_filter :set_group
  before_filter :set_user, only: [:update]
  load_and_authorize_resource
  
  respond_to :html
  
  # Handles group membership requests.
  # Currently only an Adult Sponsor can manage group requests.
  
  # POST - Create a group membership request
  def create
    @membership = Membership.new( { group: @group, user: current_user } )
    if @membership.create_request
      redirect_to group_path(@group), notice: "Membership request has been submitted"
    else
      redirect_to group_path(@group), alert: "There was an error creating your request. Try again."
    end
  end
    
  # PUT - Approve Pending Group Member
  def update
    if @membership.approve_membership
      redirect_to group_path(@group), notice: "Membership request has been accepted"
    else
      redirect_to "/notifications", alert: "There was an error approving member. Try again."
    end
  end
  
  # DELETE - Deny Pending Group Member
  def destroy
    if @membership.deny_membership
      redirect_to group_path(@group), notice: "Membership request has been denied."
    else
      redirect_to "/notifications", alert: "There was an error with the request. Try again."
    end
  end
  
  private
  
  def set_user
    @user = User.find(@membership.user_id)
  end
  
  def set_group
    @group = Group.find_by_permalink(params[:group_id])
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end
end