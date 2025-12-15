# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :views, dependent: :restrict_with_error

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :display_order, numericality: { only_integer: true }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(display_order: :asc) }

  def self.default
    find_by(slug: "daily")
  end
end
