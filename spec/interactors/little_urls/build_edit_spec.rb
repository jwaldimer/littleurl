require "rails_helper"

RSpec.describe LittleUrls::BuildEdit, type: :interactor do
  let(:original) { create(:little_url, original_url: "https://old.example.com", token: "oldToken", description: "old desc") }

  context "when a valid little_url and attributes are provided" do
    it "assigns incoming attributes onto the model without saving" do
      result = described_class.call(
        little_url: original,
        original_url: "https://new.example.com",
        token: "newToken",
        description: "new desc"
      )

      expect(result).to be_success
      expect(original.original_url).to eq("https://new.example.com")
      expect(original.token).to eq("newToken")
      expect(original.description).to eq("new desc")

      expect(original).to be_persisted
      expect(original).to be_changed
    end

    it "does not touch unrelated attributes" do
      creator_before = original.creator_id

      result = described_class.call(
        little_url: original,
        original_url: "https://new.example.com",
        token: "newToken",
        description: "new desc"
      )

      expect(result).to be_success
      expect(original.creator_id).to eq(creator_before)
    end
  end

  context "when some attributes are nil" do
    it "overwrites those attributes with nil (assign_attributes behavior)" do
      original.update!(description: "existing description")

      result = described_class.call(
        little_url: original,
        original_url: nil,
        token: "stillToken",
        description: nil
      )

      expect(result).to be_success
      expect(original.token).to eq("stillToken")
      expect(original.original_url).to be_nil
      expect(original.description).to be_nil
    end
  end

  context "when little_url is nil" do
    it "raises an error" do
      expect {
        described_class.call(
          little_url: nil,
          original_url: "https://new.example.com",
          token: "newToken",
          description: "new desc"
        )
      }.to raise_error(NoMethodError)
    end
  end
end
