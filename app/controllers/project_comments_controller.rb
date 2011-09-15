class ProjectCommentsController < ApplicationController
  layout "application"

  before_filter :authenticate_user!
  before_filter :set_group
  before_filter :set_project
  before_filter :set_comment, except: [:index, :new, :create]
  load_and_authorize_resource except: [:create]
  
  respond_to :html
  
  # Project Comments

  # GET - All Project Comments
  def index
    @comments = @project.project_comments
    respond_with(@comments)
  end

  # GET - New Project Comment Form
  def new
    @comment = ProjectComment.new
    respond_with(@comment)
  end
  
  # POST - Create Project Comment
  def create
    @comment = ProjectComment.new(params[:comment])
    @comment.user = current_user
    authorize! :create, @comment
    @comment.project = @project
    if @comment.save
      redirect_to group_project_path(@group.permalink, @project.id), notice: "Comment was added successfully."
    else
      puts @comment.errors.inspect
      render action: 'new'
    end
  end
 
  # GET - Edit Project Comment
  def edit
    respond_with(@comment)
  end
  
  # PUT - Update A Project Comment
  def update
    if @comment.update_attributes( { comment: params[:comment] } )
      redirect_to group_project_path(@group.permalink, @project.id), notice: "Comment has been updated."
    else
      render action: 'edit'
    end
  end
  
  # DELETE - Destroy A Project Comment
  def destroy
    if @comment.destroy
      redirect_to group_project_path(@group.permalink, @project.id), notice: "Comment has been deleted."
    else
      redirect_to group_project_path(@group.permalink, @project.id), alert: "There was en error deleting that comment. Try again."
    end
  end

  private
  
  def set_group
    #@group = Group.where(permalink: params[:group_id]).first
    @group = Group.find_by_permalink(params[:group_id])
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_comment
    @comment = ProjectComment.find(params[:id])
  end
end