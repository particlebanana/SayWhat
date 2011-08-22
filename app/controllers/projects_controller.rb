class ProjectsController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!, :except => [:all, :index, :filter, :show]
  before_filter :set_group_by_permalink, :except => [:all, :filter]
  before_filter :set_project, :only => [:show, :edit, :update, :delete_photo]
  
  load_and_authorize_resource :except => [:new, :create]
  
  respond_to :html
  
  # GET - Global Project Index
  # Only show upcoming projects to authenticated users for privacy reasons
  def all
    @options = (Project.new()).filters
    @projects = current_user ? Project.order('end_date DESC') : Project.order('end_date ASC').find_all{ |project| project.end_date < Date.today}
    respond_with(@projects)
  end
  
  # GET - Filter Projects Index
  # Only show upcoming projects to authenticated users for privacy reasons
  def filter
    @options = (Project.new()).filters
    
    @projects = Project.scoped
    @projects = @projects.where(:focus => params[:focus]) unless params[:focus] == 'Filter by Focus' || params[:focus] == ""
    @projects = @projects.where(:audience => params[:audience]) unless params[:audience] == 'Filter by Audience' || params[:audience] == ""
    @projects = @projects.where(:end_date < Date.today) unless current_user # restricts upcoming projects to only be viewed by logged in users
    @projects = @projects.order('end_date DESC')

    render :action => "all"
  end
  
  # GET - Group Project Index
  # Only show upcoming projects to authenticated users for privacy reasons
  def index
    @projects = {
      :upcoming => @group.projects.order('end_date ASC').find_all{ |project| project.end_date >= Date.today},
      :completed => @group.projects.order('end_date DESC').find_all{ |project| project.end_date < Date.today}
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
    @project = Project.new(:group_id => @group.id)
    authorize! :new, @project
    params[:project][:start_date] = format_calendar_date(params[:project][:start_date])
    params[:project][:end_date] =  format_calendar_date(params[:project][:end_date])
    @project = Project.new(params[:project])
    if @project.valid?
      if @project.save
        redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}"
      else
        @options = @project.filters
        render :action => 'new'
      end
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
    params[:project][:start_date] = format_calendar_date(params[:project][:start_date]) if params[:project][:start_date]
    params[:project][:end_date] =  format_calendar_date(params[:project][:end_date]) if params[:project][:end_date]
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
    
    def format_calendar_date(date_str)
      logger.info("date_str = #{date_str.inspect}")
      if date_str != '' && date_str != nil
        Date.strptime(date_str, '%m/%d/%Y')
      else
        nil
      end
    end
      
end
