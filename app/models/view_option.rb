# == Schema Information
#
# Table name: view_options
#
#  id         :integer          not null, primary key
#  content    :string                                  # 선택지 내용
#  view_id    :integer          not null               # 뷰 ID (views.id 참조)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes:
#  index_view_options_on_view_id  (view_id)
#
# Foreign Keys:
#  view_id  (view_id => views.id)
#
class ViewOption < ApplicationRecord
  belongs_to :view
  has_many :votes, dependent: :destroy

  validates :content, presence: true
end