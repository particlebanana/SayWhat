class CommentsController < ApplicationController
  layout "application"

  before_filter :authenticate_user!
  before_filter :set_attributes
  load_and_authorize_resource except: [:create]

  respond_to :html, :json

  # POST - Create Comment
  def create
    @comment = Comment.build(params[:comment], current_user, @group, @project, @parent)
    authorize! :create, @comment

    event = @comment.save

    respond_with(event) do |format|
      if @project
        format.html { redirect_to group_project_path(@group.permalink, @project), notice: "Comment was added successfully." }
      else
        format.html { redirect_to group_path(@group.permalink), notice: "Comment was added successfully." }
        format.json { render json: event.to_json }
      end
    end
  end

  private

  def set_attributes
    @group = params[:group_id] ? Group.find_by_permalink(params[:group_id]) : nil
    @project = params[:project_id] ? Project.find(params[:project_id]) : nil
    @parent = params[:comment_id] ? params[:comment_id] : nil
  end
end