module LittleUrls
  class BuildEdit < ApplicationInteractor
    def call
      context.little_url.assign_attributes(
        original_url: context.original_url,
        token: context.token,
        description: context.description
      )
    end
  end
end
