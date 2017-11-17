# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { Faker::DrWho.quote }
    task
    user

    factory :invalid_comment do
      body nil
    end
  end
end
