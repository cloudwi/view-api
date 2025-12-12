class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :view_option

  validates :user_id, uniqueness: { scope: :view_option_id, message: "이미 투표했습니다" }
  validate :one_vote_per_view

  after_create :increment_view_votes_count
  after_destroy :decrement_view_votes_count

  private

  def one_vote_per_view
    return unless user && view_option

    existing_vote = Vote.joins(:view_option)
                        .where(user_id: user_id)
                        .where(view_options: { view_id: view_option.view_id })
                        .where.not(id: id)
                        .exists?

    errors.add(:base, "이 View에 이미 투표했습니다") if existing_vote
  end

  def increment_view_votes_count
    view_option.view.increment!(:votes_count)
  end

  def decrement_view_votes_count
    view_option.view.decrement!(:votes_count)
  end
end
