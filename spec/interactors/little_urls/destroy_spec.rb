require "rails_helper"

RSpec.describe LittleUrls::Destroy, type: :interactor do
  context "when little_url exists" do
    let!(:little_url) { create(:little_url) }

    it "destroys the record and succeeds" do
      expect {
        result = described_class.call(little_url: little_url)
        expect(result).to be_success
      }.to change(LittleUrl, :count).by(-1)

      expect { little_url.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "destroys dependent visits via dependent: :destroy" do
      create(:visit, little_url: little_url)
      create(:visit, little_url: little_url)

      expect {
        described_class.call(little_url: little_url)
      }.to change(Visit, :count).by(-2)
    end
  end

  context "when destroy! raises" do
    let!(:little_url) { create(:little_url) }

    it "fails with the configured message and does not remove the record" do
      allow(little_url).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)

      expect {
        result = described_class.call(little_url: little_url)
        expect(result).to be_failure
        expect(result.message).to eq(I18n.t("little_url.destroy.failed"))
      }.not_to change(LittleUrl, :count)

      expect { little_url.reload }.not_to raise_error
    end
  end
end
