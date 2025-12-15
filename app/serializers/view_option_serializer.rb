# frozen_string_literal: true

class ViewOptionSerializer
  def initialize(view_option)
    @view_option = view_option
  end

  def as_json
    {
      id: @view_option.id,
      content: @view_option.content,
      votes_count: @view_option.votes_count
    }
  end
end
