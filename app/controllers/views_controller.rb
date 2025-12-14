class ViewsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_view, only: [ :show, :update, :destroy ]
  before_action :authorize_user!, only: [ :update, :destroy ]
  before_action :validate_search_query, only: [ :index ]

  include Paginatable

  SEARCH_QUERY_MAX_LENGTH = 100

  # GET /views
  def index
    author_id = params[:author] == "me" ? current_user&.id : nil

    @views = View.includes(:user, view_options: :votes)
                 .search_by_title(params[:q]&.strip)
                 .authored_by(author_id)
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
    render_success(serialize_view(@view, include_comments: true))
  end

  # POST /views
  def create
    @view = current_user.views.build(view_params)

    if @view.save
      render_success(serialize_view(@view), status: :created)
    else
      render_validation_errors(@view)
    end
  end

  # PATCH /views/:id
  def update
    if @view.update(view_params)
      render_success(serialize_view(@view))
    else
      render_validation_errors(@view)
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
    render_not_found("View")
  end

  def authorize_user!
    render_forbidden unless @view.user_id == current_user.id
  end

  def validate_search_query
    query = params[:q]
    return if query.blank?

    if query.length > SEARCH_QUERY_MAX_LENGTH
      render_error("QUERY_TOO_LONG", "검색어는 #{SEARCH_QUERY_MAX_LENGTH}자 이내여야 합니다")
    end
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
