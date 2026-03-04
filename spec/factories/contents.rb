FactoryBot.define do
  factory :content do
    sequence(:title) { |n| "Content #{n}" }
    social_media_url { "https://instagram.com/p/example123" }
    social_media_provider { :instagram }
    association :creator
  end
end
