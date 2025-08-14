class LittleUrlsController < ApplicationController
  before_action :set_creator_id

  def new
    @little_url = LittleUrl.new
    @urls = LittleUrl.where(creator_id: @creator_id).order(created_at: :desc)
  end

  def create
    @little_url = LittleUrl.new(little_url_params)
    @little_url.creator_id = @creator_id

    if @little_url.save
      redirect_to little_url_path(@little_url), notice: I18n.t("little_url.create.crated")
    else
      @urls = LittleUrl.where(creator_id: @creator_id)
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def info
  end

  private

  def little_url_params
    params.require(:little_url).permit(LittleUrl::CREATE_PARAMS)
  end

  def set_creator_id
    cookies.permanent.signed[:creator_id] ||= SecureRandom.uuid

    @creator_id = cookies.signed[:creator_id]
  end
end
