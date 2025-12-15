# frozen_string_literal: true

FactoryBot.define do
  factory :view_option do
    sequence(:content) { |n| "선택지 #{n}" }
    association :view

    trait :long_content do
      content { "이것은 매우 긴 선택지 내용입니다. " * 3 }
    end
  end
end
