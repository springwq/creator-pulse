require 'rails_helper'

RSpec.describe Content, type: :model do
  # Associations
  it { should belong_to(:creator) }

  # Validations
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:social_media_url) }

  # URL format validation
  describe "social_media_url format" do
    it "accepts valid URLs" do
      valid_urls = ["https://instagram.com/p/123", "http://example.com"]

      valid_urls.each do |url|
        content = build(:content, social_media_url: url)
        expect(content).to be_valid, "Expected '#{url}' to be valid"
      end
    end

    it "rejects invalid URLs" do
      invalid_urls = ["not-a-url", "ftp://bad.com", ""]

      invalid_urls.each do |url|
        content = build(:content, social_media_url: url)
        expect(content).not_to be_valid, "Expected '#{url}' to be invalid"
      end
    end
  end

  # Enum
  it { should define_enum_for(:social_media_provider).with_values(instagram: 0, tiktok: 1, youtube: 2) }

  # Enum scopes
  describe "enum scopes" do
    let!(:instagram_content) { create(:content, social_media_provider: :instagram) }
    let!(:tiktok_content) { create(:content, social_media_provider: :tiktok) }
    let!(:youtube_content) { create(:content, social_media_provider: :youtube) }

    it "filters by instagram" do
      expect(Content.instagram).to contain_exactly(instagram_content)
    end

    it "filters by tiktok" do
      expect(Content.tiktok).to contain_exactly(tiktok_content)
    end

    it "filters by youtube" do
      expect(Content.youtube).to contain_exactly(youtube_content)
    end
  end
end
