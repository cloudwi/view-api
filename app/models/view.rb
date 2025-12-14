# == Schema Information
#
# Table name: views
#
#  id          :integer          not null, primary key
#  title       :string                                  # 뷰(의견) 제목
#  user_id     :integer          not null               # 작성자 ID (users.id 참조)
#  votes_count :integer          default(0), not null   # 총 투표 수 (카운터 캐시)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes:
#  index_views_on_user_id      (user_id)
#  index_views_on_created_at   (created_at)
#  index_views_on_votes_count  (votes_count)
#  index_views_on_title        (title)
#
# Foreign Keys:
#  user_id  (user_id => users.id)
#
class View < ApplicationRecord
  belongs_to :user
  has_many :view_options, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :view_options, allow_destroy: true

  validates :title, presence: true, length: { minimum: 2, maximum: 200 }
  validate :options_count_within_range

  # 검색
  scope :search_by_title, ->(query) {
    where("title LIKE ?", "%#{sanitize_sql_like(query)}%") if query.present?
  }

  # 작성자 필터
  scope :authored_by, ->(user_id) {
    where(user_id: user_id) if user_id.present?
  }

  # 정렬
  scope :sort_by_latest, -> { order(created_at: :desc) }
  scope :sort_by_most_votes, -> { order(votes_count: :desc, created_at: :desc) }
  scope :sort_by_hot, -> {
    select("views.*,
            (views.votes_count +
             (SELECT COUNT(*) FROM comments WHERE comments.view_id = views.id) * 2 +
             CASE
               WHEN julianday('now') - julianday(views.created_at) <= 1 THEN 50
               WHEN julianday('now') - julianday(views.created_at) <= 7 THEN 20
               ELSE 0
             END) as popularity_score")
      .order("popularity_score DESC, views.created_at DESC")
  }

  def self.sorted_by(sort_type)
    case sort_type&.to_s
    when "most_votes"
      sort_by_most_votes
    when "hot"
      sort_by_hot
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
