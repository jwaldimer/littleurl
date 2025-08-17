module LittleUrls
  class Save < ApplicationInteractor
    def call
      record = context.little_url
      record.save!
    rescue ActiveRecord::RecordInvalid => e
      context.fail!(message: I18n.t('little_url.errors.persist'), errors: e.record.errors.full_messages)
    rescue ActiveRecord::RecordNotUnique
      record.errors.add(:token, I18n.t('little_url.errors.token_taken'))
      context.fail!(message: I18n.t('little_url.errors.persist'), errors: record.errors.full_messages)
    end
  end
end
