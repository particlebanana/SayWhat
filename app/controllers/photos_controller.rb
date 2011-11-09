class PhotosController < ApplicationController
  layout "application"  

  before_filter :set_group
  before_filter :set_project
  #load_and_authorize_resource

  respond_to :html

  # GET - Project Photos
  def index 
    @photos = @project.photos.order('created_at DESC')
  end

  # POST - New Project Photo
  def create
    @photo = @project.photos.new(photo: params[:file])
    @photo.save!
    render :partial => "show"
  end

  private
  
  def set_group
    @group = Group.where(permalink: params[:group_id]).first
  end
  
  def set_project
    @project = Project.find(params[:project_id])
  end
end