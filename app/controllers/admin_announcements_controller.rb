class AdminAnnouncementsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  authorize_resource class: false
  
  respond_to :html
  
  # GET - All Announcements
  def index
    @announcements = Announcement.order_by([:created_at, :desc]).limit(15)
    respond_with(@announcments)
  end
  
  # POST - Create an Announcement
  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      redirect_to "/admin/announcements", notice: "Announcement created successfully."
    else
      redirect_to "/admin/announcements", alert: "Missing fields, could not create announcement."
    end
  end

  # DELETE - Destroy an Announcement
  def destroy
    @announcement = Announcement.where('_id' => params[:id]).first
    if @announcement && @announcement.destroy
      redirect_to "/admin/announcements", notice: "Announcement has been removed."
    else
      redirect_to "/admin/announcements", alert: "There was a problem removing the announcement. Try again."
    end
  end
end