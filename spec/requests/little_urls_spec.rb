require 'rails_helper'

RSpec.describe "LittleUrlsController", type: :request do
  let(:creator_id) { SecureRandom.uuid }

  before do
    allow_any_instance_of(LittleUrlsController)
      .to receive(:creator_id)
      .and_return(creator_id)
  end

  describe "GET /little_urls/new" do
    it "render a new LittleUrl and assign little urls list via interactor List" do
      urls = build_list(:little_url, 2, creator_id: creator_id)
      allow(LittleUrls::List).to receive(:call)
        .with(creator_id: creator_id)
        .and_return(ok(little_urls: urls))

      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(I18n.t('little_url.new.title'))
      expect(LittleUrls::List).to have_received(:call).with(creator_id: creator_id)
    end
  end

  describe "POST /little_urls" do
    let(:params) do
      {
        little_url: {
          original_url: "https://example.com/page",
          token: "tokenExample",
          description: "description"
        }
      }
    end

    it "redirect to root with notice if Create is successful" do
      url = build(:little_url, creator_id: creator_id)
      allow(LittleUrls::Create).to receive(:call)
        .with(params: params[:little_url].symbolize_keys, cookies: kind_of(ActionDispatch::Cookies::CookieJar))
        .and_return(ok(little_url: url))

      allow(LittleUrls::List).to receive(:call)
        .with(creator_id: creator_id)
        .and_return(ok(little_urls: [ url ]))

      post little_urls_path, params: params

      expect(response).to redirect_to(root_path(url))
      follow_redirect!
      expect(flash[:notice]).to eq(I18n.t('little_url.create.created'))
    end

    it "render new with 422 and alert if Create fails" do
      allow(LittleUrls::Create).to receive(:call)
        .and_return(fail_result(message: "Invalid token", payload: { little_url: LittleUrl.new }))

      allow(LittleUrls::List).to receive(:call)
        .with(creator_id: creator_id)
        .and_return(ok(little_urls: []))

      post little_urls_path, params: { little_url: { original_url: "", token: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Invalid token")
    end
  end

  describe "GET /little_urls/:id/edit" do
    it "render edit" do
      url = build(:little_url, id: 123, creator_id: creator_id)
      allow(LittleUrls::FindObject).to receive(:call)
        .with(id: url.id.to_s)
        .and_return(ok(little_url: url))
      allow(LittleUrls::List).to receive(:call)
        .with(creator_id: creator_id)
        .and_return(ok(little_urls: [ url ]))

      get edit_little_url_path(url.id)

      expect(response).to have_http_status(:ok)
      expect(LittleUrls::FindObject).to have_received(:call).with(id: url.id.to_s)
      expect(LittleUrls::List).to have_received(:call).with(creator_id: creator_id)
    end
  end

  describe "PATCH /little_urls/:id" do
    let(:url) { build(:little_url, id: 456, creator_id: creator_id) }
    before do
      allow(LittleUrls::FindObject).to receive(:call)
        .with(id: url.id.to_s)
        .and_return(ok(little_url: url))
    end
    let(:update_params) do
      { little_url: { original_url: "https://new.com", token: "newToken" } }
    end

    it "redirect to root with notice if Update is successful" do
      allow(LittleUrls::Update).to receive(:call)
        .with(id: url.id.to_s, params: update_params[:little_url].symbolize_keys)
        .and_return(ok(little_url: url))

      patch little_url_path(url.id), params: update_params

      expect(response).to redirect_to(root_path(url))
      follow_redirect!
      expect(flash[:notice]).to eq(I18n.t('little_url.update.updated'))
    end

    it "render edit 422 with alert if Update fails" do
      allow(LittleUrls::Update).to receive(:call)
        .and_return(fail_result(message: "Unauthorized"))

      patch little_url_path(url.id), params: update_params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Unauthorized")
    end
  end

  describe "DELETE /little_urls/:id" do
    let(:url) { build(:little_url, id: 789, creator_id: creator_id) }

    it "redirect with notice if Delete is successful" do
      allow(LittleUrls::Delete).to receive(:call)
        .with(id: url.id.to_s, creator_id: creator_id)
        .and_return(ok)

      delete little_url_path(url.id)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(flash[:notice]).to eq(I18n.t('little_url.destroy.deleted'))
    end

    it "redirect with alert if Delete fails" do
      allow(LittleUrls::Delete).to receive(:call)
        .and_return(fail_result(message: "Unauthorized"))

      delete little_url_path(url.id)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(flash[:alert]).to eq("Unauthorized")
    end
  end

  describe "DELETE /little_urls/destroy_all" do
    it "redirect with notice if DestroyAll is successful" do
      allow(LittleUrls::DestroyAll).to receive(:call)
        .with(creator_id: creator_id)
        .and_return(ok)

      delete destroy_all_little_urls_path

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(flash[:notice]).to eq(I18n.t('little_url.destroy_all.deleted'))
    end

    it "redirect with alert if DestroyAll fails" do
      allow(LittleUrls::DestroyAll).to receive(:call)
        .and_return(fail_result(message: "fail"))

      delete destroy_all_little_urls_path

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(flash[:alert]).to eq(I18n.t('little_url.destroy_all.failed'))
    end
  end
end
