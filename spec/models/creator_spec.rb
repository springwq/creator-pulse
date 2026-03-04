require 'rails_helper'

RSpec.describe Creator, type: :model do
  subject { build(:creator) }

  # Associations
  it { should have_many(:contents).dependent(:destroy) }

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  # Email format validation
  describe "email format validation" do
    it "accepts valid emails" do
      creator = build(:creator, email: "user@example.com")
      expect(creator).to be_valid
    end

    it "rejects invalid emails" do
      invalid_emails = [ "not-an-email", "foo@", "@bar.com" ]

      invalid_emails.each do |invalid_email|
        creator = build(:creator, email: invalid_email)
        expect(creator).not_to be_valid, "Expected '#{invalid_email}' to be invalid"
      end
    end
  end

  # Scopes
  describe ".ordered_by_name" do
    it "returns creators in alphabetical order by name" do
      charlie = create(:creator, name: "Charlie")
      alice = create(:creator, name: "Alice")
      bob = create(:creator, name: "Bob")

      expect(Creator.ordered_by_name).to eq([ alice, bob, charlie ])
    end
  end

  describe ".with_content_count" do
    it "returns creators with their content count" do
      creator_with_contents = create(:creator)
      create_list(:content, 3, creator: creator_with_contents)

      creator_without_contents = create(:creator)

      results = Creator.with_content_count.order(:id)

      result_with = results.find { |c| c.id == creator_with_contents.id }
      result_without = results.find { |c| c.id == creator_without_contents.id }

      expect(result_with.content_count).to eq(3)
      expect(result_without.content_count).to eq(0)
    end
  end

  describe ".search_by_name" do
    before do
      create(:creator, name: "Alice Johnson")
      create(:creator, name: "Bob Smith")
      create(:creator, name: "Charlie Alice")
    end

    it "returns creators matching the search query (case insensitive)" do
      results = Creator.search_by_name("alice")

      expect(results.count).to eq(2)
      expect(results.pluck(:name)).to contain_exactly("Alice Johnson", "Charlie Alice")
    end

    it "performs case-insensitive search" do
      results = Creator.search_by_name("ALICE")

      expect(results.count).to eq(2)
    end

    it "returns empty when no match is found" do
      results = Creator.search_by_name("Zara")

      expect(results).to be_empty
    end
  end
end
