# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { Faker::DrWho.quote }
    task
    user
  end
end
