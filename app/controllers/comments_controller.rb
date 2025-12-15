class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]
  before_action :set_view
  before_action :set_comment, only: [ :update, :destroy ]
  before_action :authorize_comment_owner!, only: [ :update, :destroy ]

  # GET /views/:view_id/comments
  def index
    @comments = @view.comments.includes(:user).order(created_at: :asc)
    render_success(@comments.map { |comment| CommentSerializer.new(comment).as_json })
  end

  # POST /views/:view_id/comments
  def create
    @comment = @view.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      render_success(CommentSerializer.new(@comment).as_json, status: :created)
    else
      render_validation_errors(@comment)
    end
  end

  # PATCH /views/:view_id/comments/:id
  def update
    if @comment.update(comment_params)
      render_success(CommentSerializer.new(@comment).as_json)
    else
      render_validation_errors(@comment)
    end
  end

  # DELETE /views/:view_id/comments/:id
  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def set_view
    @view = View.find(params[:view_id])
  rescue ActiveRecord::RecordNotFound
    render_not_found("View")
  end

  def set_comment
    @comment = @view.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_not_found("Comment")
  end

  def authorize_comment_owner!
    render_forbidden unless @comment.user_id == current_user.id
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
