# frozen_string_literal: true

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
      category: category_json,
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
      response[:comments_count] = @view.comments_count
    end

    response
  end

  private

  def category_json
    @category_json ||= {
      id: @view.category.id,
      name: @view.category.name,
      slug: @view.category.slug
    }
  end

  def author_json
    @author_json ||= {
      id: @view.user.id,
      nickname: @view.user.nickname
    }
  end

  def options_json
    @options_json ||= @view.view_options.map { |opt| ViewOptionSerializer.new(opt).as_json }
  end

  def my_vote_json
    return nil unless @current_user

    @my_vote_json ||= begin
      # 이미 로드된 view_options의 votes에서 찾기 (추가 쿼리 방지)
      @view.view_options.each do |opt|
        vote = opt.votes.find { |v| v.user_id == @current_user.id }
        return { option_id: opt.id } if vote
      end
      nil
    end
  end

  def comments_json
    @comments_json ||= begin
      # 이미 로드된 comments 사용, 정렬은 메모리에서 수행
      sorted_comments = @view.comments.sort_by(&:created_at)
      sorted_comments.map { |comment| CommentSerializer.new(comment).as_json }
    end
  end
end
