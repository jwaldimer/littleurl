module LittleUrls
  class List < ApplicationInteractor
    def call
      creator_id = context.creator_id
      context.little_urls = LittleUrl.where(creator_id: creator_id).order(created_at: :desc)
    end
  end
end
