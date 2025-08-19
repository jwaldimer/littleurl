require "rails_helper"

RSpec.describe LittleUrls::BuildNew, type: :interactor do
  let(:attrs) do
    {
      original_url: "https://example.com/path",
      token:        "myToken",
      description:  "some desc",
      creator_id:   SecureRandom.uuid
    }
  end

  it "builds a new LittleUrl in context without persisting" do
    expect {
      result = described_class.call(**attrs)
      expect(result).to be_success
      expect(result.little_url).to be_a(LittleUrl)
      expect(result.little_url).not_to be_persisted

      expect(result.little_url.original_url).to eq(attrs[:original_url])
      expect(result.little_url.token).to eq(attrs[:token])
      expect(result.little_url.description).to eq(attrs[:description])
      expect(result.little_url.creator_id).to eq(attrs[:creator_id])
    }.not_to change(LittleUrl, :count)
  end

  it "allows nil attributes" do
    result = described_class.call(
      original_url: nil,
      token:        nil,
      description:  nil,
      creator_id:   nil
    )

    expect(result).to be_success
    expect(result.little_url).to be_a(LittleUrl)
    expect(result.little_url).not_to be_persisted
    expect(result.little_url.original_url).to be_nil
    expect(result.little_url.token).to be_nil
    expect(result.little_url.description).to be_nil
    expect(result.little_url.creator_id).to be_nil

    expect(result.little_url).not_to be_valid
  end
end
