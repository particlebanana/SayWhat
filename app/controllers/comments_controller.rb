class CommentsController < ApplicationController
  layout "application"

  before_filter :authenticate_user!
  before_filter :set_group
  before_filter :set_project
  load_and_authorize_resource except: [:create]

  respond_to :html, :json

  # POST - Create Comment
  def create
    @comment = Comment.new({
      comment: params[:comment],
      objects: { user: "user:#{current_user.id}" },
    })
    authorize! :create, @comment

    # Project Comment
    if @project
      @comment.objects.merge!({ project: "project:#{@project.id}" })
      @comment.timelines = ["project:#{@project.id}"]
    # Nested Comment
    elsif params[:comment_id]
      @comment.parent = params[:comment_id]
      @comment.timelines = ["#{params[:comment_id]}"]
    # Group Comment
    else
      @comment.objects.merge!({ group: "group:#{@group.id}" })
      @comment.timelines = ["group:#{@group.id}"]
    end

    url = @comment.save
    comment = HTTParty.get(url).body

    respond_with(comment) do |format|
      if @project
        format.html { redirect_to group_project_path(@group.permalink, @project), notice: "Comment was added successfully." }
      else
        format.html { redirect_to group_path(@group.permalink), notice: "Comment was added successfully." }
        format.json { render json: comment.to_json }
      end
    end
  end

  private

  def set_group
    @group = Group.find_by_permalink(params[:group_id])
  end

  def set_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end
end