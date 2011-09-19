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
end