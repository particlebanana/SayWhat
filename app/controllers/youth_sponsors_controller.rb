class YouthSponsorsController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  before_filter :set_user
  before_filter :set_group
  
  respond_to :html
  
  #
  # Youth Sponsors are a user role that has certain administrative abilities
  # within a group's scope. They are tasked with being a moderator for their
  # peers within a group. 
  #
  # The only role that is above a Youth Sponsor within a group is the Adult Sponsor.
  # An Adult Sponsor is the only role that can perform the actions listed below.
  # The role is managed solely by the Adult Sponsor within the group's edit view.
  #
    
  # GET - Show a groups active members
  def index
    authorize! :view_potential_sponsors, User
    @members = @group.users.active.members
    respond_with(@members)
  end
  
  # PUT - Update a user to youth sponsor role
  def update
    authorize! :update_youth_sponsor, User
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
    authorize! :destroy_youth_sponsor, User
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
