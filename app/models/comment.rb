# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text                                     # 댓글 내용
#  user_id    :integer          not null               # 작성자 ID (users.id 참조)
#  view_id    :integer          not null               # 뷰 ID (views.id 참조)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes:
#  index_comments_on_user_id  (user_id)
#  index_comments_on_view_id  (view_id)
#
# Foreign Keys:
#  user_id  (user_id => users.id)
#  view_id  (view_id => views.id)
#
class Comment < ApplicationRecord
  belongs_to :view, counter_cache: true
  belongs_to :user

  validates :content, presence: true, length: { minimum: 1, maximum: 2000 }
end
