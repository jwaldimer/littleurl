class LittleUrlsController < ApplicationController
  before_action :set_little_url, only: [:show, :edit, :update]

  def new
    @little_url = LittleUrl.new
    set_url_list
  end

  def create
    result = LittleUrls::Create.call(
      params: little_url_params.to_h.symbolize_keys,
      cookies: cookies
    )
    set_url_list

    if result.success?
      redirect_to root_path(result.little_url), notice: I18n.t('little_url.create.created')
    else
      @little_url = result.little_url || LittleUrl.new(little_url_params)
      flash.now[:alert] = [
        result.message,
        (result.respond_to?(:errors) && result.errors.present? ? result.errors.to_sentence : nil)
      ].compact.join(': ')
      render :new, status: :unprocessable_entity      
    end
  end

  def show; end

  def edit; end
  
  def update
    result = LittleUrls::Update.call(
      little_url: @little_url,
      params: little_url_params.to_h.symbolize_keys
    )

    if result.success?
      redirect_to root_path(result.little_url), notice: I18n.t('little_url.update.updated')
    else
      flash.now[:alert] = result.message
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def little_url_params
    params.require(:little_url).permit(LittleUrl::CREATE_PARAMS)
  end

  def set_url_list
    @urls = LittleUrls::List.call(creator_id: creator_id).little_urls
  end

  def set_little_url
    @little_url = LittleUrl.friendly.find(params[:id])
  end
end
