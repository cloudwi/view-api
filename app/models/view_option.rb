class ViewOption < ApplicationRecord
  belongs_to :view
  has_many :votes, dependent: :destroy

  validates :content, presence: true
end