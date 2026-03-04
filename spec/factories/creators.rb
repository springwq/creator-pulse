FactoryBot.define do
  factory :creator do
    sequence(:name) { |n| "Creator #{n}" }
    sequence(:email) { |n| "creator#{n}@example.com" }
  end
end
