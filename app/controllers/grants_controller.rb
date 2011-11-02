class GrantsController < ApplicationController
  layout "application"

  before_filter :authenticate_user!
  before_filter :set_group
  before_filter :set_project
  before_filter :set_grant, only: [:edit, :update]

  respond_to :html

  # GET - New Grant Application
  def new
    @grant = Grant.new({ project: @project })
    authorize! :new, @grant

    @grant = Grant.new
    respond_with(@grant)
  end

  # POST - Create a new Grant Application
  #
  # If user is the group's adult sponsor then just send them directly
  # to the edit page to finalize the application.
  #
  # If user is not the group's adult sponsor then they should be redirected
  # to the project page and an email sent to the adult sponsor notifying them
  # there is an open grant application.
  def create
    @grant = Grant.new(params[:grant])
    authorize! :create, @grant
    @grant.member = current_user
    if @grant.save
      if current_user.adult_sponsor?
        redirect_to edit_group_project_grant_path(@group, @project, @grant)
      else
        @grant.notify_sponsor_of_application(request.env["HTTP_HOST"], current_user)
        redirect_to group_project_path(@group, @project), notice: 'Grant has been submitted for further processing.'
      end
    else
      render action: 'new'
    end
  end

  # GET - Grant Finalization
  def edit
    authorize! :edit, @grant
    respond_with(@grant)
  end

  # PUT - Update Grant to finalize application
  def update
    authorize! :update, @grant
    @grant.status = 'completed'
    if @grant.update_attributes(params[:grant])
      redirect_to group_project_path(@group, @project), notice: "Grant has been submitted for final approval."
    else
      render action: "edit"
    end
  end

  private 

  def set_group
    @group = Group.where(permalink: params[:group_id]).first
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_grant
    @grant = Grant.find(params[:id])
  end
end