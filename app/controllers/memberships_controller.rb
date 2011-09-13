class MembershipsController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  before_filter :set_user
  before_filter :set_group
  
  respond_to :html
  
  # Handles group membership requests.
  # Currently only an Adult Sponsor can manage group requests.
  
  # POST - Create a group membership request
  def create
    authorize! :create_pending_group_request, Message 
    if @message = Message.create_group_request(@group, @user, @group.adult_sponsor)
      redirect_to group_path(@group), notice: "Membership request has been submitted"
    else
      redirect_to group_path(@group), alert: "There was an error creating your request. Try again."
    end
  end
    
  # PUT - Approve Pending Group Member
  def update
    authorize! :approve_pending_group_member, User
    if @user.activate
      message = current_user.messages.find(params[:message])
      message.delete
      UserMailer.send_approved_notice(@user, @group, request.env["HTTP_HOST"]).deliver
      redirect_to "/messages", :notice => "Member has been added to group."
    else
      redirect_to "/messages", :alert => "There was an error approving user."
    end
  end
  
  # DELETE - Deny Pending Group Member
  def destroy
    authorize! :deny_pending_group_member, User
    if @user.destroy
      message = current_user.messages.find(params[:message])
      message.delete
      redirect_to "/messages", :notice => "Member has been removed"
    else
      redirect_to "/messages", :alert => "Error removing user. Try again."
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:user_id])
  end
  
  def set_group
    @group = Group.where(permalink: params[:group_id]).first
  end
end
