# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title             { Faker::DrWho.quote }
    description       { Faker::Lorem.paragraph }
    user
  end
end
