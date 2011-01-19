class ProjectsController < ApplicationController
  layout "main"
  
  before_filter :authenticate_user!, :except => [:all, :index, :filter, :show]
  before_filter :set_group_by_permalink, :except => [:all, :filter]
  before_filter :set_project, :only => [:show, :edit, :update, :delete_photo]
  
  load_and_authorize_resource :except => [:new, :create]
  
  respond_to :html
  
  # GET - Global Project Index
  # Only show upcoming projects to authenticated users for privacy reasons
  def all
    @options = (Project.new()).filters
    @projects = ProjectCache.all.desc(:end_date) if current_user
    @projects = ProjectCache.desc(:end_date).find_all{ |project| project.end_date < Date.today} unless current_user
    respond_with(@projects)
  end
  
  # GET - Filter Projects Index
  # Only show upcoming projects to authenticated users for privacy reasons
  def filter
    @options = (Project.new()).filters
    @projects = ProjectCache.filter(params[:focus], params[:audience]).desc(:end_date) if current_user
    @projects = ProjectCache.filter(params[:focus], params[:audience]).desc(:end_date).find_all{ |project| project.end_date < Date.today} unless current_user
    render :action => "all"
  end
  
  # GET - Group Project Index
  # Only show upcoming projects to authenticated users for privacy reasons
  def index
    @projects = {
      :upcoming => @group.projects.asc(:end_date).find_all{ |project| project.end_date >= Date.today},
      :completed => @group.projects.desc(:end_date).find_all{ |project| project.end_date < Date.today}
    }
    respond_with(@projects)
  end
  
  # GET - Project Page
  # Only show upcoming projects to authenticated users for privacy reasons
  def show
    if @project.end_date >= Date.today && !current_user
      redirect_to "/groups/#{@group.permalink}/projects", :notice => "error with project lookup"
    else
      @comment = Comment.new() if current_user
      respond_with(@project)
    end
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
    format_calendar_dates
    if @project.update_attributes(params[:project])
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}" 
    else
      @options = @project.filters
      render :action => "edit"
    end
  end
  
  # GET - Delete Profile Photo
  def delete_photo
    @project.remove_profile_photo!
    @project.profile_photo_filename = nil
    @project.save
    redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}/edit"
  end
  
  
  private 
  
    def set_group_by_id
      @group = Group.find(params[:group_id])
    end
    
    def set_group_by_permalink
      @group = Group.where(:permalink => params[:permalink]).first
    end
    
    def set_project
      @project = @group.projects.where(:name => params[:name]).first
    end
    
    def format_calendar_dates
      start = Date.strptime(params[:project][:start_date], "%m/%d/%Y") if params[:project][:start_date]
      stop = Date.strptime(params[:project][:end_date], "%m/%d/%Y") if params[:project][:end_date]
      params[:project][:start_date] = start if start
      params[:project][:end_date] = stop if stop
    end
  
end
