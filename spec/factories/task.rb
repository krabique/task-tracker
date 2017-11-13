# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title             { Faker::DrWho.quote }
    description       { Faker::Lorem.paragraph }
    status            %w[waiting implementation verifying releasing].sample
    user
    project
  end
end
