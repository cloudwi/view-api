# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    association :user
    association :view_option
  end
end
