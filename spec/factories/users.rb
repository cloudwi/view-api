# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    encrypted_password { "password123" }
    sequence(:nickname) { |n| "테스트유저#{n}" }
    provider { "kakao" }
    sequence(:uid) { |n| "kakao_uid_#{n}" }

    trait :without_nickname do
      nickname { nil }
    end
  end
end
