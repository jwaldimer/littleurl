require "rails_helper"

RSpec.describe "RedirectsController", type: :request do
  describe "GET /:id (redirect)" do
    let(:little_url) { build(:little_url, original_url: "https://rubyonrails.org/") }

    it "permanently redirects (301) to the original_url when found" do
      expect(Visits::Create).to receive(:call).with(
        id: little_url.token,
        request: kind_of(ActionDispatch::Request)
      ).and_return(ok(little_url: little_url))

      get redirect_path(little_url.slug)

      expect(response).to have_http_status(:moved_permanently) # 301
      expect(response.headers["Location"]).to eq(little_url.original_url)
      # No seguimos el redirect; basta con confirmar Location/Status
    end

    it "redirects to root with alert if not found (RecordNotFound)" do
      allow(Visits::Create).to receive(:call)
        .and_raise(ActiveRecord::RecordNotFound)

      get redirect_path("no-existe")

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(flash[:alert]).to eq(I18n.t("redirects.not_found"))
    end

    it "allows external hosts in the Location" do
      external = build(:little_url, original_url: "https://external.example.com/landing")
      allow(Visits::Create).to receive(:call)
        .and_return(ok(little_url: external))

      get redirect_path(external.slug)

      expect(response).to have_http_status(:moved_permanently)
      expect(response.headers["Location"]).to eq("https://external.example.com/landing")
    end
  end
end
