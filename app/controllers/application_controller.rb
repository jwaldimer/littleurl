class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def creator_id
    LittleUrls::SetCreatorId.call(cookies: cookies).creator_id
  end
end
