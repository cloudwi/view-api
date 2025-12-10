class ViewsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_view, only: [ :show, :update, :destroy ]
  before_action :authorize_user!, only: [ :update, :destroy ]

  # GET /views
  def index
    @views = View.includes(:user, :view_options).order(created_at: :desc)
    render json: @views.map { |view| view_response(view) }
  end

  # GET /views/:id
  def show
    render json: view_response(@view, include_comments: true)
  end

  # POST /views
  def create
    @view = current_user.views.build(view_params)

    if @view.save
      render json: view_response(@view), status: :created
    else
      render json: { errors: @view.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /views/:id
  def update
    if @view.update(view_params)
      render json: view_response(@view)
    else
      render json: { errors: @view.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /views/:id
  def destroy
    @view.destroy
    head :no_content
  end

  private

  def set_view
    @view = View.includes(:user, :view_options, comments: :user).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "View not found" }, status: :not_found
  end

  def authorize_user!
    render json: { error: "Forbidden" }, status: :forbidden unless @view.user_id == current_user.id
  end

  def view_params
    params.require(:view).permit(
      :title,
      view_options_attributes: [ :id, :content, :_destroy ]
    )
  end

  def view_response(view, include_comments: false)
    response = {
      id: view.id,
      title: view.title,
      author: {
        id: view.user.id,
        nickname: view.user.nickname
      },
      options: view.view_options.map { |opt| { id: opt.id, content: opt.content } },
      created_at: view.created_at,
      updated_at: view.updated_at,
      edited: view.updated_at != view.created_at
    }

    if include_comments
      response[:comments] = view.comments.order(created_at: :asc).map do |comment|
        {
          id: comment.id,
          content: comment.content,
          author: {
            id: comment.user.id,
            nickname: comment.user.nickname
          },
          created_at: comment.created_at
        }
      end
    else
      response[:comments_count] = view.comments.size
    end

    response
  end

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    return render_unauthorized unless token

    decoded = JwtService.decode(token)
    return render_unauthorized unless decoded

    @current_user = User.find_by(id: decoded[:user_id])
    render_unauthorized unless @current_user
  end

  def current_user
    @current_user
  end

  def render_unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
