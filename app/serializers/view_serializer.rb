class ViewSerializer
  def initialize(view, current_user: nil, include_comments: false)
    @view = view
    @current_user = current_user
    @include_comments = include_comments
  end

  def as_json
    response = {
      id: @view.id,
      title: @view.title,
      author: author_json,
      options: options_json,
      total_votes: options_json.sum { |o| o[:votes_count] },
      my_vote: my_vote_json,
      created_at: @view.created_at,
      updated_at: @view.updated_at,
      edited: @view.updated_at != @view.created_at
    }

    if @include_comments
      response[:comments] = comments_json
    else
      response[:comments_count] = @view.comments.size
    end

    response
  end

  private

  def author_json
    {
      id: @view.user.id,
      nickname: @view.user.nickname
    }
  end

  def options_json
    @options_json ||= @view.view_options.map do |opt|
      {
        id: opt.id,
        content: opt.content,
        votes_count: opt.votes.size
      }
    end
  end

  def my_vote_json
    return nil unless @current_user

    option_ids = @view.view_options.map(&:id)
    vote = @current_user.votes.find_by(view_option_id: option_ids)
    vote ? { option_id: vote.view_option_id } : nil
  end

  def comments_json
    @view.comments.order(created_at: :asc).map do |comment|
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
  end
end
