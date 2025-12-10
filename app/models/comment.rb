class Comment < ApplicationRecord
  belongs_to :view
  belongs_to :user

  validates :content, presence: true
end
