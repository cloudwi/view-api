# frozen_string_literal: true

class CategoriesController < ApplicationController
  # GET /categories
  def index
    @categories = Category.active.ordered

    render_success(@categories.map { |cat| serialize_category(cat) })
  end

  private

  def serialize_category(category)
    {
      id: category.id,
      name: category.name,
      slug: category.slug,
      description: category.description,
      icon: category.icon
    }
  end
end
