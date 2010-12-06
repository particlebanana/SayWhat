class ProjectsController < ApplicationController
  layout "main"
  
  before_filter :authenticate_user!
  before_filter :set_group_by_permalink
  before_filter :set_project, :only => [:show, :edit, :update]
  
  load_and_authorize_resource
  
  respond_to :html
  
  # GET - Group Project Index
  def index
    @projects = @group.projects
    respond_with(@projects)
  end
  
  # GET - Project Page
  def show
    @comments = @project.comments
    @comment = Comment.new
    respond_with(@project)
  end
  
  # GET - New Project Page
  def new
    @project = Project.new
    @options = @project.filters
    respond_with(@project)
  end
  
  # POST - Create New Project
  def create
    @project = Project.new(params[:project])
    @group.projects << @project
    if @project.save && @group.save
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}"
    else
      @options = @project.filters
      render :action => 'new'
    end
  end
  
  # GET - Edit Project
  def edit
    respond_with(@project)
  end
  
  # PUT - Update Project
  def update
    if @project.update_attributes(params[:project])
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}" 
    else
      render :action => "edit"
    end
  end
  
  
  private 
  
    def set_group_by_id
      @group = Group.find(params[:group_id])
    end
    
    def set_group_by_permalink
      @group = Group.find(:first, :conditions => {:permalink => params[:permalink]})
    end
    
    def set_project
      @project = @group.projects.where(:name => params[:name]).first
    end
  
end
