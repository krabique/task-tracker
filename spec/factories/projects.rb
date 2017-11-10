FactoryBot.define do
  factory :user do
    email             { Faker::Internet.email }
    name              { Faker::DrWho.character }
    developer_role    false
    manager_role      true
    password          'abcd1234'
  end
  
  factory :project do
    title             { Faker::DrWho.quote }
    description       { Faker::Lorem.paragraph }
  end
end
