# frozen_string_literal: true

FactoryBot.define do
  factory :sleep_time do
    started_at { Time.current }
    user
  end
end