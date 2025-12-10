class View < ApplicationRecord
  belongs_to :user
  has_many :view_options, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :view_options, allow_destroy: true

  validates :title, presence: true
  validate :options_count_within_range

  private

  def options_count_within_range
    if view_options.reject(&:marked_for_destruction?).size < 2
      errors.add(:view_options, "최소 2개의 선택사항이 필요합니다")
    elsif view_options.reject(&:marked_for_destruction?).size > 20
      errors.add(:view_options, "최대 20개의 선택사항만 가능합니다")
    end
  end
end
