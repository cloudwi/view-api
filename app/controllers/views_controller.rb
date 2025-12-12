class ViewsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_current_user, only: [ :index, :show ]
  before_action :set_view, only: [ :show, :update, :destroy ]
  before_action :authorize_user!, only: [ :update, :destroy ]

  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100

  # GET /views
  def index
    @views = View.includes(:user, view_options: :votes)
                 .search_by_title(params[:q])
                 .sorted_by(params[:sort])

    @views = apply_cursor_pagination(@views).to_a
    has_next = @views.size > per_page
    @views = @views[0...-1] if has_next

    render json: {
      data: @views.map { |view| view_response(view) },
      meta: {
        per_page: per_page,
        has_next: has_next,
        next_cursor: has_next ? encode_cursor(@views.last) : nil
      }
    }
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

  def view_response(view, include_comments: false)
    options = view.view_options.map do |opt|
      {
        id: opt.id,
        content: opt.content,
        votes_count: opt.votes.size
      }
    end

    response = {
      id: view.id,
      title: view.title,
      author: {
        id: view.user.id,
        nickname: view.user.nickname
      },
      options: options,
      total_votes: options.sum { |o| o[:votes_count] },
      my_vote: my_vote_for(view),
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

  def set_current_user
    token = request.headers["Authorization"]&.split(" ")&.last
    return unless token

    decoded = JwtService.decode(token)
    return unless decoded

    @current_user = User.find_by(id: decoded[:user_id])
  end

  def my_vote_for(view)
    return nil unless current_user

    vote = current_user.votes.find { |v| view.view_options.any? { |opt| opt.id == v.view_option_id } }
    vote ? { option_id: vote.view_option_id } : nil
  end

  def per_page
    [ (params[:per_page] || DEFAULT_PER_PAGE).to_i, MAX_PER_PAGE ].min
  end

  def apply_cursor_pagination(scope)
    limit = per_page + 1  # 다음 페이지 존재 여부 확인용

    if params[:cursor].present?
      cursor_data = decode_cursor(params[:cursor])
      scope = apply_cursor_condition(scope, cursor_data)
    end

    scope.limit(limit)
  end

  def apply_cursor_condition(scope, cursor_data)
    sort_type = params[:sort]&.to_s

    case sort_type
    when "most_votes"
      scope.where(
        "(votes_count < :votes) OR (votes_count = :votes AND created_at < :created_at) OR (votes_count = :votes AND created_at = :created_at AND id < :id)",
        votes: cursor_data[:votes_count],
        created_at: cursor_data[:created_at],
        id: cursor_data[:id]
      )
    when "oldest"
      scope.where(
        "(created_at > :created_at) OR (created_at = :created_at AND id > :id)",
        created_at: cursor_data[:created_at],
        id: cursor_data[:id]
      )
    else # latest (default)
      scope.where(
        "(created_at < :created_at) OR (created_at = :created_at AND id < :id)",
        created_at: cursor_data[:created_at],
        id: cursor_data[:id]
      )
    end
  end

  def encode_cursor(view)
    data = {
      id: view.id,
      created_at: view.created_at.iso8601(6),
      votes_count: view.votes_count
    }
    Base64.urlsafe_encode64(data.to_json)
  end

  def decode_cursor(cursor)
    data = JSON.parse(Base64.urlsafe_decode64(cursor))
    {
      id: data["id"],
      created_at: Time.parse(data["created_at"]),
      votes_count: data["votes_count"]
    }
  rescue
    {}
  end
end
