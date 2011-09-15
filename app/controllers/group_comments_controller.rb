class GroupCommentsController < ApplicationController
  layout "application"

  before_filter :authenticate_user!
  before_filter :set_group
  before_filter :set_comment, except: [:index, :new, :create]
  load_and_authorize_resource except: [:create]
  
  respond_to :html
  
  # Group Comments

  # GET - All Group Comments
  def index
    @comments = @group.group_comments
    respond_with(@comments)
  end

  # GET - New Project Comment Form
  def new
    @comment = GroupComment.new
    respond_with(@comment)
  end
  
  # POST - Create Project Comment
  def create
    @comment = GroupComment.new(params[:comment])
    @comment.user = current_user
    authorize! :create, @comment
    @comment.group = @group
    if @comment.save
      redirect_to group_path(@group.permalink), notice: "Comment was added successfully."
    else
      puts @comment.errors.inspect
      render action: 'new'
    end
  end
 
  # GET - Edit Group Comment
  def edit
    respond_with(@comment)
  end
  
  # PUT - Update A Group Comment
  def update
    if @comment.update_attributes( { comment: params[:comment] } )
      redirect_to group_path(@group.permalink), notice: "Comment has been updated."
    else
      render action: 'edit'
    end
  end
  
  # DELETE - Destroy A Group Comment
  def destroy
    if @comment.destroy
      redirect_to group_path(@group.permalink), notice: "Comment has been deleted."
    else
      redirect_to group_path(@group.permalink), alert: "There was en error deleting that comment. Try again."
    end
  end

  private
  
  def set_group
    @group = Group.find_by_permalink(params[:group_id])
  end

  def set_comment
    @comment = GroupComment.find(params[:id])
  end
end