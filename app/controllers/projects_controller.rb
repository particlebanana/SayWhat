class ProjectsController < ApplicationController
  layout "main"
  
  before_filter :authenticate_user!
  before_filter :set_group_by_permalink#, :only => [:index, :new, :show]
  #before_filter :set_group_by_id, :only => [:create]
  
  load_and_authorize_resource
  
  respond_to :html
  
  # GET - Group Project Index
  def index
    @projects = @group.projects
    respond_with(@projects)
  end
  
  # GET - Project Page
  def show
    @project = @group.projects.where(:name => params[:name]).first
    respond_with(@project)
  end
  
  # GET - New Project Page
  def new
    @project = Project.new
    respond_with(@project)
  end
  
  # POST - Create New Project
  def create
    @project = Project.new(params[:project])
    @group.projects << @project
    if @project.save && @group.save
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}"
    else
      render :action => 'new'
    end
  end
  
  
  private 
  
    def set_group_by_id
      @group = Group.find(params[:group_id])
    end
    
    def set_group_by_permalink
      @group = Group.find(:first, :conditions => {:permalink => params[:permalink]})
    end
  
end
