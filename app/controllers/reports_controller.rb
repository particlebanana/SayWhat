class ReportsController < ApplicationController
  layout "main"
  
  before_filter :authenticate_user!
  before_filter :set_group_by_permalink
  before_filter :set_project
  
  load_and_authorize_resource
  
  respond_to :html
  
  # GET - Reporting form for a project
  def new
    @report = Report.new()
    @options = @report.filters
    respond_with(@report)
  end
  
  # POST - Create a report for a project
  def create
    @report = Report.new(params[:report])
    @project.report = @report
    if @report.save && @project.save
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}"
    else
      @options = @report.filters
      render :action => 'new'
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
