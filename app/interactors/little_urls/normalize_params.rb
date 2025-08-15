module LittleUrls
  class NormalizeParams < ApplicationInteractor

    def call
      params = context.params

      context.original_url = params[:original_url].to_s.strip
      context.token        = params[:token].presence&.strip
      context.description  = params[:description].to_s.strip.presence
    end
  end
end
