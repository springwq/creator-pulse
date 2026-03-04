require 'rails_helper'

RSpec.describe Contents::Create do
  describe "#call" do
    context "with valid params" do
      let(:creator) { create(:creator) }
      let(:valid_params) do
        {
          title: "My Instagram Post",
          social_media_url: "https://instagram.com/p/abc123",
          social_media_provider: "instagram"
        }
      end

      it "returns a successful result" do
        result = described_class.new(creator.id, valid_params).call

        expect(result).to be_success
        expect(result).not_to be_failure
      end

      it "creates a new content record" do
        expect {
          described_class.new(creator.id, valid_params).call
        }.to change(Content, :count).by(1)
      end

      it "associates content with the correct creator" do
        result = described_class.new(creator.id, valid_params).call

        expect(result.data).to be_a(Content)
        expect(result.data.creator).to eq(creator)
        expect(result.data.title).to eq("My Instagram Post")
        expect(result.data.social_media_url).to eq("https://instagram.com/p/abc123")
        expect(result.data.social_media_provider).to eq("instagram")
      end
    end

    context "with invalid params" do
      let(:creator) { create(:creator) }

      it "returns a failure result when title is blank" do
        params = {
          title: "",
          social_media_url: "https://instagram.com/p/abc123",
          social_media_provider: "instagram"
        }
        result = described_class.new(creator.id, params).call

        expect(result).to be_failure
        expect(result).not_to be_success
        expect(result.errors).to have_key(:title)
      end

      it "returns a failure result when URL is invalid" do
        params = {
          title: "My Post",
          social_media_url: "not-a-url",
          social_media_provider: "instagram"
        }
        result = described_class.new(creator.id, params).call

        expect(result).to be_failure
        expect(result.errors).to have_key(:social_media_url)
      end

      it "does not create a record on failure" do
        params = {
          title: "",
          social_media_url: "not-a-url",
          social_media_provider: "instagram"
        }

        expect {
          described_class.new(creator.id, params).call
        }.not_to change(Content, :count)
      end
    end

    context "when creator does not exist" do
      let(:non_existent_id) { 999_999 }
      let(:params) do
        {
          title: "My Post",
          social_media_url: "https://instagram.com/p/abc123",
          social_media_provider: "instagram"
        }
      end

      it "returns a failure result with creator error" do
        result = described_class.new(non_existent_id, params).call

        expect(result).to be_failure
        expect(result.errors).to have_key(:creator)
        expect(result.errors[:creator]).to include("not found")
      end

      it "does not create any record" do
        expect {
          described_class.new(non_existent_id, params).call
        }.not_to change(Content, :count)
      end
    end
  end
end
