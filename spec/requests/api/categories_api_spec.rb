# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Categories API", type: :request do
  describe "GET /categories" do
    before do
      create(:category, name: "일상", slug: "daily", display_order: 0, active: true)
      create(:category, name: "음식", slug: "food", display_order: 1, active: true)
      create(:category, name: "비활성", slug: "inactive", display_order: 2, active: false)
      create(:category, name: "여행", slug: "travel", display_order: 3, active: true)
    end

    it "활성화된 카테고리 목록을 반환한다" do
      get "/categories"

      expect(response).to have_http_status(:ok)
      expect(json_response[:data].size).to eq(3)
    end

    it "display_order 순으로 정렬된다" do
      get "/categories"

      slugs = json_response[:data].map { |c| c[:slug] }
      expect(slugs).to eq(%w[daily food travel])
    end

    it "각 카테고리에 필요한 필드가 포함된다" do
      get "/categories"

      category = json_response[:data].first
      expect(category).to include(:id, :name, :slug, :description, :icon)
    end

    it "비활성화된 카테고리는 포함되지 않는다" do
      get "/categories"

      slugs = json_response[:data].map { |c| c[:slug] }
      expect(slugs).not_to include("inactive")
    end
  end
end
