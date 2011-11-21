class PhotosController < ApplicationController
  layout "application"  

  before_filter :set_group
  before_filter :set_project

  respond_to :html

  # GET - Project Photos
  def index 
    @photos = @project.photos.order('created_at DESC')
  end

  # POST - New Project Photo
  def create
    @photo = @project.photos.new(photo: params[:file])
    authorize! :create, @photo
    @photo.save!
    render :partial => "show"
  end

  #GET - "Edit" mode for project photos
  def edit
    @photo = @project.photos.new(photo: params[:file])
    authorize! :destroy, @photo
    @photos = @project.photos.order('created_at DESC')
  end

  # Destroy a photo
  def destroy
    @photo = ProjectPhoto.find(params[:id])
    authorize! :destroy, @photo
    if @photo.destroy
      redirect_to group_project_photos_path(@group.permalink, @project), notice: "Photo has beed destroyed"
    else
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.id}/photos/edit", alert: "Error destroying photo"
    end
  end

  private
  
  def set_group
    @group = Group.where(permalink: params[:group_id]).first
  end
  
  def set_project
    @project = Project.find(params[:project_id])
  end
end