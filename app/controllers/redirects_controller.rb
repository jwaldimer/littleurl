class RedirectsController < ApplicationController

  def show
    little_url = LittleUrl.friendly.find(params[:id])
    LittleUrls::TrackVisit.call(little_url: little_url, ip: request.remote_ip)

    redirect_to little_url.original_url, allow_other_host: true, status: :moved_permanently
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: I18n.t('redirects.not_found')
  end
end
