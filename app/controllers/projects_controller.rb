class ProjectsController < ApplicationController
  layout "main"
  
  before_filter :authenticate_user!
  before_filter :set_group_by_permalink, :except => [:all]
  before_filter :set_project, :only => [:show, :edit, :update]
  
  load_and_authorize_resource :except => [:new, :create]
  
  respond_to :html
  
  # GET - Global Project Index
  def all
    @projects = ProjectCache.all.desc(:created_at)
    respond_with(@projects)
  end
  
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
    @project = Project.new(:group_id => @group.id.to_s)
    authorize! :new, @project
    @options = @project.filters
    respond_with(@project)
  end
  
  # POST - Create New Project
  def create
    @project = Project.new(:group_id => @group.id.to_s)
    authorize! :new, @project
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
    @options = @project.filters
    respond_with(@project)
  end
  
  # PUT - Update Project
  def update
    if @project.update_attributes(params[:project])
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}" 
    else
      @options = @project.filters
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
