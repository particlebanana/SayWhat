class MembershipsController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  before_filter :set_user
  before_filter :set_group
  before_filter :set_membership, except: :create
  load_and_authorize_resource
  
  respond_to :html
  
  # Handles group membership requests.
  # Currently only an Adult Sponsor can manage group requests.
  
  # POST - Create a group membership request
  def create
    @membership = Membership.new( { group: @group, user: current_user } )
    if @membership.save
      redirect_to group_path(@group), notice: "Membership request has been submitted"
    else
      redirect_to group_path(@group), alert: "There was an error creating your request. Try again."
    end
  end
    
  # PUT - Approve Pending Group Member
  def update
    if @user.activate && @membership.destroy
      @membership.publish
      UserMailer.send_approved_notice(@user, @group, request.env["HTTP_HOST"]).deliver
      redirect_to "/messages", :notice => "Member has been added to group."
    else
      redirect_to "/messages", :alert => "There was an error approving member."
    end
  end
  
  # DELETE - Deny Pending Group Member
  def destroy
    if @membership.destroy
      redirect_to "/messages", :notice => "Membership request has been denied."
    else
      redirect_to "/messages", :alert => "Error processing request. Try again."
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:user_id])
  end
  
  def set_group
    @group = Group.find_by_permalink(params[:group_id])
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end
end