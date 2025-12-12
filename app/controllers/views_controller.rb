class ViewsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_view, only: [ :show, :update, :destroy ]
  before_action :authorize_user!, only: [ :update, :destroy ]

  include Paginatable

  # GET /views
  def index
    @views = View.includes(:user, view_options: :votes)
                 .search_by_title(params[:q])
                 .sorted_by(params[:sort])

    @views = apply_cursor_pagination(@views).to_a
    has_next = @views.size > per_page
    @views = @views[0...-1] if has_next

    render json: {
      data: @views.map { |view| serialize_view(view) },
      meta: {
        per_page: per_page,
        has_next: has_next,
        next_cursor: has_next ? encode_cursor(@views.last) : nil
      }
    }
  end

  # GET /views/:id
  def show
    render json: serialize_view(@view, include_comments: true)
  end

  # POST /views
  def create
    @view = current_user.views.build(view_params)

    if @view.save
      render json: serialize_view(@view), status: :created
    else
      render json: { errors: @view.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /views/:id
  def update
    if @view.update(view_params)
      render json: serialize_view(@view)
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
    @view = View.includes(:user, view_options: :votes, comments: :user).find(params[:id])
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

  def serialize_view(view, include_comments: false)
    ViewSerializer.new(view, current_user: current_user, include_comments: include_comments).as_json
  end
end
