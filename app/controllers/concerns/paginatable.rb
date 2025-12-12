module Paginatable
  extend ActiveSupport::Concern

  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100

  private

  def per_page
    [ (params[:per_page] || DEFAULT_PER_PAGE).to_i, MAX_PER_PAGE ].min
  end

  def apply_cursor_pagination(scope)
    limit = per_page + 1

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
    else
      scope.where(
        "(created_at < :created_at) OR (created_at = :created_at AND id < :id)",
        created_at: cursor_data[:created_at],
        id: cursor_data[:id]
      )
    end
  end

  def encode_cursor(record)
    data = {
      id: record.id,
      created_at: record.created_at.iso8601(6),
      votes_count: record.votes_count || 0
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
  rescue JSON::ParserError, ArgumentError
    {}
  end
end
