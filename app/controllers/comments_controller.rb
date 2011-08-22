class CommentsController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user!
  before_filter :set_group_by_permalink
  before_filter :set_project
  before_filter :set_comment, :except => [:new, :create]
  
  load_and_authorize_resource
  
  respond_to :html
  
  # GET - New Comment Form
  def new
    @comment = Comment.new
    respond_with(@comment)
  end
  
  # POST - Create a new comment
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @comment.project = @project
    if @comment.valid? && @comment.save
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :notice => "Comment successfully posted"
    else
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :alert => "Comment can't be blank"
    end
  end
  
  # GET - Edit a comment
  def edit
    redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :notice => "This comment doesn't belong to you!" unless @comment.user == current_user
  end
  
  # PUT - Update a comment
  def update
    if @comment.user == current_user
      if @comment.update_attributes(params[:comment]) 
        redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :notice => "Comment has been updated"
      else
        render :action => 'edit'
      end
    else
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :notice => "This comment doesn't belong to you!"
    end
  end
  
  # DELETE - Destroy a comment as a group sponsor
  def destroy
    @comment.destroy
    redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :notice => "Comment has been removed"
  end
  
  private 
    
    def set_group_by_permalink
      @group = Group.where(:permalink => params[:permalink]).first
    end
    
    def set_project
      @project = @group.projects.where(:name => params[:name]).first
    end
    
    def set_comment
      @comment = @project.comments.find(params[:comment_id])
    end
    
end
