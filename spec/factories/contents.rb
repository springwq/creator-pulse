FactoryBot.define do
  factory :content do
    title { "MyString" }
    social_media_url { "MyString" }
    social_media_provider { 1 }
    creator { nil }
  end
end
