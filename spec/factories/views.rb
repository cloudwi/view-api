# frozen_string_literal: true

FactoryBot.define do
  factory :view do
    sequence(:title) { |n| "테스트 뷰 #{n}" }
    association :user
    category { Category.first || create(:category) }

    after(:build) do |view|
      if view.view_options.empty?
        view.view_options.build(content: "선택지 A")
        view.view_options.build(content: "선택지 B")
      end
    end

    trait :food do
      category { Category.find_by(slug: "food") || create(:category, :food) }
      title { "오늘 점심 뭐 먹을까?" }
    end

    trait :travel do
      category { Category.find_by(slug: "travel") || create(:category, :travel) }
      title { "여행 어디로 갈까?" }
    end

    trait :work do
      category { Category.find_by(slug: "work") || create(:category, :work) }
      title { "회사 야근 어떻게 생각해?" }
    end

    trait :with_many_options do
      after(:build) do |view|
        view.view_options.clear
        5.times { |i| view.view_options.build(content: "선택지 #{i + 1}") }
      end
    end

    trait :with_votes do
      after(:create) do |view|
        3.times do
          user = create(:user)
          create(:vote, user: user, view_option: view.view_options.first)
        end
      end
    end

    trait :with_comments do
      after(:create) do |view|
        3.times { create(:comment, view: view) }
      end
    end

    trait :popular do
      after(:create) do |view|
        10.times do
          user = create(:user)
          create(:vote, user: user, view_option: view.view_options.sample)
        end
        5.times { create(:comment, view: view) }
      end
    end
  end
end
