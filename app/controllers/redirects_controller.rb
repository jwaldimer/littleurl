class RedirectsController < ApplicationController

  def show
    result = Visits::Create.call(id: params[:id], request: request)
    little_url = result.little_url

    redirect_to little_url.original_url, allow_other_host: true, status: :moved_permanently
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: I18n.t('redirects.not_found')
  end
end
