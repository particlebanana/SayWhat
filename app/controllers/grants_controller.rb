class GrantsController < ApplicationController
  layout "application"

  before_filter :authenticate_user!
  before_filter :set_group
  before_filter :set_project

  respond_to :html

  # GET - New Grant Application
  def new
    @grant = Grant.new({ project: @project })
    authorize! :new, @grant

    @grant = Grant.new
    respond_with(@grant)
  end

  # POST - Create a new Grant Application
  def create
    @grant = Grant.new(params[:grant])
    authorize! :create, @grant
    @grant.member = current_user
    if @grant.save
      redirect_to group_project_path(@group, @project), notice: 'Grant has been submitted for approval.'
    else
      render action: 'new'
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