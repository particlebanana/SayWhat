class ProjectsController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!, except: [:overview, :index, :show]
  before_filter :set_group, except: [:overview]
  before_filter :set_project, except: [:overview, :index, :new, :create]
  load_and_authorize_resource except: [:create]
  
  respond_to :html

  # All Projects Overview
  def overview
    @projects = Project.order('updated_at DESC')
    respond_with(@projects)
  end

  # Group Projects
  
  # GET - All Group Projects
  def index
    @projects = @group.projects.order('created_at DESC')
    respond_with(@projects)
  end
  
  # GET - New Group Project Form
  def new
    @project = Project.new
    respond_with(@project)
  end
  
  # POST - Create New Group Project
  def create
    project = Project.new(group_id: @group.id)
    authorize! :new, project
    @project = @group.projects.new(params[:project])
    @project.format_dates(params[:project][:start_date], params[:project][:end_date])
    if @project.save
      redirect_to group_project_path(@group.permalink, @project.id), notice: "Project was added successfully."
    else
      render action: 'new'
    end
  end
  
  # GET - Show Single Group Project
  def show
    @timeline = Hashie::Mash.new($feed.timeline("project:#{@project.id}"))
    respond_with(@project)
  end
  
  # GET - Edit A Group Project
  def edit
    respond_with(@project)
  end
  
  # PUT - Update A Group Project
  def update
    project = @project.attributes.merge!(params[:project])
    @project.format_dates(project["start_date"], project["end_date"])
    if @project.update_attributes(project.except("start_date", "end_date"))
      redirect_to group_project_path(@group.permalink, @project.id), notice: "Project has been updated."
    else
      render action: 'edit'
    end
  end
  
  # DELETE - Destroy A Group Project
  def destroy
    if @project.destroy
      redirect_to group_projects_path(@group.permalink), notice: "Project has been deleted."
    else
      redirect_to group_project_path(@group.permalink, @project.id), alert: "There was en error deleting this project. Try again."
    end
  end

  private
  
  def set_group
    @group = Group.where(permalink: params[:group_id]).first
  end
  
  def set_project
    @project = Project.find(params[:id])
  end
end
