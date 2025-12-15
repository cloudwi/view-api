# frozen_string_literal: true

class CommentSerializer
  def initialize(comment)
    @comment = comment
  end

  def as_json
    {
      id: @comment.id,
      content: @comment.content,
      author: author_json,
      created_at: @comment.created_at
    }
  end

  private

  def author_json
    {
      id: @comment.user.id,
      nickname: @comment.user.nickname
    }
  end
end
