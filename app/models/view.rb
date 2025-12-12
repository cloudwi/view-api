class View < ApplicationRecord
  belongs_to :user
  has_many :view_options, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :view_options, allow_destroy: true

  validates :title, presence: true
  validate :options_count_within_range

  # 검색
  scope :search_by_title, ->(query) {
    where("title LIKE ?", "%#{sanitize_sql_like(query)}%") if query.present?
  }

  # 정렬
  scope :sort_by_latest, -> { order(created_at: :desc) }
  scope :sort_by_oldest, -> { order(created_at: :asc) }
  scope :sort_by_most_votes, -> { order(votes_count: :desc, created_at: :desc) }

  def self.sorted_by(sort_type)
    case sort_type&.to_s
    when "oldest"
      sort_by_oldest
    when "most_votes"
      sort_by_most_votes
    else
      sort_by_latest
    end
  end

  private

  def options_count_within_range
    if view_options.reject(&:marked_for_destruction?).size < 2
      errors.add(:view_options, "최소 2개의 선택사항이 필요합니다")
    elsif view_options.reject(&:marked_for_destruction?).size > 20
      errors.add(:view_options, "최대 20개의 선택사항만 가능합니다")
    end
  end
end
