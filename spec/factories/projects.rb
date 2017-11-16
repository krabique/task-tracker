# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title             { Faker::DrWho.quote }
    description       { Faker::Lorem.paragraph }
    user

    factory :invalid_project do
      title             nil
      description       nil
      user
    end

    factory :project_with_users do
      users { create_list(:developer, 2) }
    end
  end
end
