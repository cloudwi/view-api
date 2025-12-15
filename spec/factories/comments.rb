# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph(sentence_count: 2) }
    association :user
    association :view

    trait :long_content do
      content { Faker::Lorem.paragraph(sentence_count: 20) }
    end

    trait :short_content do
      content { "좋아요!" }
    end
  end
end
