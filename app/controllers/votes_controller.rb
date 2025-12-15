class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_view

  # POST /views/:view_id/vote
  def create
    view_option = @view.view_options.find_by(id: params[:view_option_id])
    return render_not_found("ViewOption") unless view_option

    @vote = current_user.votes.build(view_option: view_option)

    if @vote.save
      render_success(vote_result, status: :created)
    else
      render_validation_errors(@vote)
    end
  end

  # DELETE /views/:view_id/vote
  def destroy
    vote = find_user_vote

    if vote
      vote.destroy
      render_success(vote_result)
    else
      render_not_found("Vote")
    end
  end

  private

  def set_view
    @view = View.includes(view_options: :votes).find(params[:view_id])
  rescue ActiveRecord::RecordNotFound
    render_not_found("View")
  end

  def find_user_vote
    # 이미 로드된 데이터에서 검색 (추가 쿼리 방지)
    @view.view_options.each do |opt|
      vote = opt.votes.find { |v| v.user_id == current_user.id }
      return vote if vote
    end
    nil
  end

  def vote_result
    # 투표 후 데이터 갱신을 위해 reload
    @view.reload
    @view.view_options.reload.each { |opt| opt.votes.reload }

    options = @view.view_options.map do |opt|
      {
        id: opt.id,
        content: opt.content,
        votes_count: opt.votes.length
      }
    end

    my_vote = find_user_vote

    {
      view_id: @view.id,
      options: options,
      total_votes: options.sum { |o| o[:votes_count] },
      my_vote: my_vote ? { option_id: my_vote.view_option_id } : nil
    }
  end
end
