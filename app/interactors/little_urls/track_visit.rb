module LittleUrls
  class TrackVisit < ApplicationInteractor

    def call
      little_url = context.little_url

      little_url.visits.create!(ip_address: context.ip, user_agent: context.user_agent)
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.warn(e.record.errors.full_messages.join(', '))
    end
  end
end
