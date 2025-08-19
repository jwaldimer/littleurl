require "rails_helper"

RSpec.describe LittleUrls::Authorize, type: :interactor do
  let(:owner_id)   { SecureRandom.uuid }
  let(:other_id)   { SecureRandom.uuid }
  let(:little_url) { build(:little_url, creator_id: owner_id) }

  subject(:result) { described_class.call(little_url: little_url, creator_id: creator_id) }

  context "when the creator_id matches" do
    let(:creator_id) { owner_id }

    it "is successful" do
      expect(result).to be_success
      expect(result.message).to be_nil
    end
  end

  context "when the creator_id does NOT match" do
    let(:creator_id) { other_id }

    it "fails with 'forbidden' message" do
      expect(result).to be_failure
      expect(result.message).to eq(I18n.t("little_url.errors.forbidden"))
    end
  end

  context "when creator_id is nil" do
    let(:creator_id) { nil }

    it "fails" do
      expect(result).to be_failure
      expect(result.message).to eq(I18n.t("little_url.errors.forbidden"))
    end
  end

  context "when little_url is nil" do
    let(:creator_id) { owner_id }
    let(:little_url) { nil }

    it "throws an error because trying to access creator_id of nil" do
      expect { result }.to raise_error(NoMethodError)
    end
  end
end
