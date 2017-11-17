# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email             { Faker::Internet.email }
    name              { Faker::DrWho.character }
    developer_role    true
    password          'abcd1234'

    factory :manager do
      developer_role  false
      manager_role    true
    end

    factory :developer do
      developer_role  true
      manager_role    false
    end
  end
end
