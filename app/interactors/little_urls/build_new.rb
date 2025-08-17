module LittleUrls
  class BuildNew < ApplicationInteractor
    def call
      context.little_url = LittleUrl.new(
        original_url: context.original_url,
        token: context.token,
        description: context.description,
        creator_id: context.creator_id
      )
    end
  end
end
