class CommentsController < ApplicationController
  layout "main"
  
  before_filter :authenticate_user!
  before_filter :set_group_by_permalink
  before_filter :set_project
  
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
    if @comment.valid?
      @project.comments << @comment
      if @comment.save && @project.save
        redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :notice => "Comment successfully posted"
      else
        redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :alert => "Comment can't be blank"
      end
    else
      redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :alert => "Comment can't be blank"
    end
  end
  
  # DELETE - Destroy a comment as a group sponsor
  def destroy
    @comment = @project.comments.find(params[:comment_id])
    @comment.destroy
    redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}", :notice => "Comment has been removed"
  end
  
  private 
    
    def set_group_by_permalink
      @group = Group.find(:first, :conditions => {:permalink => params[:permalink]})
    end
    
    def set_project
      @project = @group.projects.where(:name => params[:name]).first
    end
    
end
