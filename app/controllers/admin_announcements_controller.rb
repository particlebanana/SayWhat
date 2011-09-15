class AdminAnnouncementsController < ApplicationController
  layout "admin"
  
  before_filter :authenticate_user!
  authorize_resource class: false
  
  respond_to :html
  
  # GET - All Announcements
  def index
    @announcements = Announcement.last
    respond_with(@announcments)
  end
  
  # POST - Create an Announcement
  def create
    if params[:announcement]
      obj = { title: params[:announcement][:title], text: params[:announcement][:text] }
      Announcement.insert(obj)
      redirect_to "/admin/announcements", notice: "Announcement created successfully."
    else
      redirect_to "/admin/announcements", alert: "Missing fields, could not create announcement."
    end
  end
end