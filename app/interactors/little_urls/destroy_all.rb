module LittleUrls
  class DestroyAll < ApplicationInteractor
    def call
      creator_id = context.creator_id
      context.fail!(message: I18n.t('little_url.destroy_all.missing')) if creator_id.blank?

      LittleUrl.transaction do
        LittleUrl.where(creator_id: creator_id).find_each(&:destroy)
      end
    end
  end
end
