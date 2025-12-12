class VotesController < ApplicationController
  before_action :authenticate_user!

  # POST /views/:view_id/vote
  def create
    view = View.find(params[:view_id])
    view_option = view.view_options.find(params[:view_option_id])

    @vote = current_user.votes.build(view_option: view_option)

    if @vote.save
      render json: vote_result(view), status: :created
    else
      render json: { errors: @vote.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "View or option not found" }, status: :not_found
  end

  # DELETE /views/:view_id/vote
  def destroy
    view = View.find(params[:view_id])
    vote = current_user.votes.joins(:view_option)
                       .where(view_options: { view_id: view.id })
                       .first

    if vote
      vote.destroy
      render json: vote_result(view)
    else
      render json: { error: "Vote not found" }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "View not found" }, status: :not_found
  end

  private

  def vote_result(view)
    options = view.view_options.includes(:votes).map do |opt|
      {
        id: opt.id,
        content: opt.content,
        votes_count: opt.votes.size
      }
    end

    my_vote = current_user.votes.joins(:view_option)
                          .where(view_options: { view_id: view.id })
                          .first

    {
      view_id: view.id,
      options: options,
      total_votes: options.sum { |o| o[:votes_count] },
      my_vote: my_vote ? { option_id: my_vote.view_option_id } : nil
    }
  end
end
