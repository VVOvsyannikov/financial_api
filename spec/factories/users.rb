FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    balance { 0.0 }
  end
end
