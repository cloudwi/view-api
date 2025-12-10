class ViewOption < ApplicationRecord
  belongs_to :view

  validates :content, presence: true
end
