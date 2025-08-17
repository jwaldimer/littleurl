module LittleUrls
  class Authorize < ApplicationInteractor
    def call
      little_url = context.little_url
      creator_id = context.creator_id

      return unless little_url.creator_id != creator_id
      context.fail!(message: I18n.t('little_url.errors.forbidden'))
    end
  end
end
