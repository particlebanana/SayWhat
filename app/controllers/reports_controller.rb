class ReportsController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  before_filter :set_group_by_permalink
  before_filter :set_project
  
  respond_to :html
  
  # GET - Reporting form for a project
  def new
    if @project.end_date < Date.today
      authorize! :new, @report = Report.new(project_id: @project.id)
      @report = Report.new()
      @options = @report.filters
      respond_with(@report)
    else
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :notice => "Can only report on finished projects"
    end
  end
  
  # POST - Create a report for a project
  def create
    if @project.end_date < Date.today
      authorize! :new, @report = Report.new(project_id: @project.id)
      @report = Report.new(params[:report])
      @report.project_id = @project.id
      if @report.save
        redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :notice => "Report Successfully Submitted"
      else
        @options = @report.filters
        render :action => 'new'
      end
    else
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :notice => "Can only report on finished projects"
    end
  end
  
  
  private 
      
    def set_group_by_permalink
      @group = Group.where(:permalink => params[:permalink]).first
    end
    
    def set_project
      @project = @group.projects.where(:name => params[:name]).first
    end  
end
