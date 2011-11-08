class ReportsController < ApplicationController
  layout "application"

  before_filter :authenticate_user!
  before_filter :set_group
  before_filter :set_project

  respond_to :html

  # GET - Reporting form for a project
  def new
    @report = Report.new(project_id: @project.id)
    authorize! :new, @report
    @options = @report.filters
    respond_with(@report)
  end

  # POST - Create a report for a project
  def create
    @report = Report.new(params[:report])
    @report.project_id = @project.id
    authorize! :new, @report
    if @report.save
      redirect_to group_project_path(@group.permalink, @project), notice: "Report Successfully Submitted"
    else
      @options = @report.filters
      render :action => 'new'
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
