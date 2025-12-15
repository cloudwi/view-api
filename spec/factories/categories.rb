# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "카테고리 #{n}" }
    sequence(:slug) { |n| "category-#{n}" }
    description { "테스트 카테고리 설명" }
    icon { "📌" }
    sequence(:display_order) { |n| n }
    active { true }

    trait :daily do
      name { "일상" }
      slug { "daily" }
      description { "일상적인 이야기" }
      icon { "☀️" }
    end

    trait :food do
      name { "음식" }
      slug { "food" }
      description { "맛집, 요리, 음식 추천" }
      icon { "🍔" }
    end

    trait :travel do
      name { "여행" }
      slug { "travel" }
      description { "여행, 휴가" }
      icon { "✈️" }
    end

    trait :work do
      name { "직장" }
      slug { "work" }
      description { "직장생활, 커리어" }
      icon { "💼" }
    end

    trait :inactive do
      active { false }
    end
  end
end
