module LittleUrls
  class Destroy < ApplicationInteractor
    def call
      context.little_url.destroy!
    rescue => e
      context.fail!(message: I18n.t('little_url.destroy.failed'))
    end
  end
end
