# frozen_string_literal: true

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
    @view = View.includes(:view_options).find(params[:view_id])
  rescue ActiveRecord::RecordNotFound
    render_not_found("View")
  end

  def find_user_vote
    current_user.votes.joins(:view_option)
                .where(view_options: { view_id: @view.id })
                .first
  end

  def vote_result
    # 투표 후 counter cache 갱신을 위해 view_options만 reload
    @view.view_options.reload

    options = @view.view_options.map { |opt| ViewOptionSerializer.new(opt).as_json }
    my_vote = find_user_vote

    {
      view_id: @view.id,
      options: options,
      total_votes: options.sum { |o| o[:votes_count] },
      my_vote: my_vote ? { option_id: my_vote.view_option_id } : nil
    }
  end
end
