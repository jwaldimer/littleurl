module Visits
  class TrackVisit < ApplicationInteractor

    def call
      little_url = context.little_url
      request = context.request

      little_url.visits.create!(ip_address: request.ip, user_agent: request.user_agent)
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.warn(e.record.errors.full_messages.join(', '))
    end
  end
end
