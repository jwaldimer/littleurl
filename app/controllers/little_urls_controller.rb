class LittleUrlsController < ApplicationController
  before_action :set_little_url, only: %i[edit]

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
      flash.now[:alert] = result.message
      render :new, status: :unprocessable_entity      
    end
  end

  def edit
    set_url_list
  end
  
  def update
    result = LittleUrls::Update.call(
      id: params[:id],
      params: little_url_params.to_h.symbolize_keys
    )

    if result.success?
      redirect_to root_path(result.little_url), notice: I18n.t('little_url.update.updated')
    else
      flash.now[:alert] = result.message
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    result = LittleUrls::Delete.call(id: params[:id], creator_id: creator_id)

    if result.success?
      redirect_to root_path, notice: t('little_url.destroy.deleted')
    else
      redirect_to root_path, alert: result.message
    end    
  end

  def destroy_all
    result = LittleUrls::DestroyAll.call(creator_id: creator_id)

    if result.success?
      redirect_to root_path, notice: t('little_url.destroy_all.deleted')
    else
      redirect_to root_path, alert: t('little_url.destroy_all.failed')
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
    @little_url = LittleUrls::FindObject.call(id: params[:id]).little_url
  end
end
