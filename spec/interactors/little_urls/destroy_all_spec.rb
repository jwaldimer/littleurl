require "rails_helper"

RSpec.describe LittleUrls::DestroyAll, type: :interactor do
  let(:owner_id) { SecureRandom.uuid }
  let(:other_id) { SecureRandom.uuid }

  context "when creator_id is present" do
    it "destroys all URLs for one creator and leaves others untouched" do
      little_url1 = create(:little_url, creator_id: owner_id)
      little_url2 = create(:little_url, creator_id: owner_id)
      little_url3 = create(:little_url, creator_id: other_id)

      expect {
        result = described_class.call(creator_id: owner_id)
        expect(result).to be_success
      }.to change { LittleUrl.where(creator_id: owner_id).count }
        .from(2).to(0)
        .and change { LittleUrl.where(creator_id: other_id).count }.by(0)

      expect { little_url1.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { little_url2.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect { little_url3.reload }.not_to raise_error
    end

    it "removes dependent visits (if any) via dependent: :destroy" do
      url = create(:little_url, creator_id: owner_id)
      create(:visit, little_url: url)
      create(:visit, little_url: url)

      expect {
        described_class.call(creator_id: owner_id)
      }.to change(Visit, :count).by(-2)
    end
  end

  context "transactional behavior" do
    it "rolls back all deletions if a destroy raises" do
      u1 = create(:little_url, creator_id: owner_id)
      u2 = create(:little_url, creator_id: owner_id)

      allow_any_instance_of(LittleUrl).to receive(:destroy).and_wrap_original do |orig, *args|
        # Raise on the first call only
        @__raised ||= false
        unless @__raised
          @__raised = true
          raise StandardError, "boom"
        end
        orig.call(*args)
      end

      expect {
        expect {
          described_class.call(creator_id: owner_id)
        }.to raise_error(StandardError, /boom/)
      }.not_to change { LittleUrl.where(creator_id: owner_id).count }

      expect { u1.reload }.not_to raise_error
      expect { u2.reload }.not_to raise_error
    end
  end
end
