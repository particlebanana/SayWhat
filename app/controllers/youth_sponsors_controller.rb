class YouthSponsorsController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  before_filter :set_user
  before_filter :set_group
  #load_and_authorize_resource
  #authorize_resource
  
  respond_to :html
    
  # GET - Show a groups active members
  def index
    @members = @group.users.active.members
    respond_with(@members)
  end
  
  # PUT - Update a user to youth sponsor role
  def update
    return redirect_to "/groups/#{@group.permalink}/edit", alert: "Error assigning youth sponsor" unless params[:user_id]
    sponsor = User.where(id: params[:user_id]).first
    if sponsor && sponsor.change_role_level('youth sponsor')
      UserMailer.send_sponsor_promotion(sponsor, @group).deliver
      redirect_to "/groups/#{@group.permalink}/edit", notice: "Youth sponsor updated"
    else
      redirect_to "/groups/#{@group.permalink}/edit", alert: "Error assigning youth sponsor"
    end
  end
  
  # DELETE - Remove youth sponsor role
  def destroy
    return redirect_to "/groups/#{@group.permalink}/edit", alert: "Error assigning youth sponsor" unless params[:user_id]
    sponsor = User.where(id: params[:user_id]).first
    if sponsor && sponsor.change_role_level('member')
      UserMailer.send_sponsor_revocation(sponsor, @group).deliver
      redirect_to "/groups/#{@group.permalink}/edit", notice: "Youth sponsor removed"
    else
      redirect_to "/groups/#{@group.permalink}/edit", alert: "Error removing youth sponsor"
    end
  end

  private
  
  def set_user
    @user = current_user
  end
  
  def set_group
    @group = @user.group
  end
end
