require "rails_helper"

RSpec.describe LittleUrls::Save, type: :interactor do
  let(:creator_id) { SecureRandom.uuid }

  context "when attributes are valid" do
    it "persists the record and succeeds" do
      record = build(:little_url,
        original_url: "https://example.com/path",
        token: "validToken",
        creator_id: creator_id
      )

      expect {
        result = described_class.call(little_url: record)
        expect(result).to be_success
        expect(record).to be_persisted
      }.to change(LittleUrl, :count).by(1)
    end
  end

  context "when validations fail" do
    it "returns failure with translated message and exposes model errors" do
      record = build(:little_url,
        original_url: nil,
        token: "someToken",
        creator_id: creator_id
      )

      result = described_class.call(little_url: record)

      expect(result).to be_failure
      expect(result.message).to eq(I18n.t("little_url.errors.persist"))

      expect(result.errors).to be_an(Array)
      expect(result.errors.join(" ")).to match(/must be valid|can't be blank/)
      expect(record).not_to be_persisted
    end
  end

  context "when the database raises RecordNotUnique" do
    it "adds a token error, returns failure and does not persist" do
      record = build(:little_url,
        original_url: "https://example.com",
        token: "dupToken",
        creator_id: creator_id
      )

      allow(record).to receive(:save!).and_raise(ActiveRecord::RecordNotUnique.new("PG::UniqueViolation"))

      result = nil
      expect {
        result = described_class.call(little_url: record)
        expect(result).to be_failure
        expect(result.message).to eq(I18n.t("little_url.errors.persist"))
      }.not_to change(LittleUrl, :count)

      expect(record.errors[:token]).to include(I18n.t("little_url.errors.token_taken"))
      expect(result.errors).to include(*record.errors.full_messages)
      expect(record).not_to be_persisted
    end
  end

  context "when little_url is nil" do
    it "raises with the current implementation (NoMethodError)" do
      expect {
        described_class.call(little_url: nil)
      }.to raise_error(NoMethodError)
    end
  end
end
