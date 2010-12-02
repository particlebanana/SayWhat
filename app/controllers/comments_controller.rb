class CommentsController < ApplicationController
  layout "main"
  
  before_filter :authenticate_user!
  before_filter :set_group_by_permalink
  before_filter :set_project, :only => [:create, :edit, :update]
  
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
        redirect_to "/groups/#{@group.permalink}/projects/#{@project.name}"
      else
        render :action => 'new'
      end
    else
      render :action => 'new'
    end
  end
  
  private 
    
    def set_group_by_permalink
      @group = Group.find(:first, :conditions => {:permalink => params[:permalink]})
    end
    
    def set_project
      @project = @group.projects.where(:name => params[:name]).first
    end
    
end
