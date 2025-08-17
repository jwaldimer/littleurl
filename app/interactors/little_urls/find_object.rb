module LittleUrls
  class FindObject < ApplicationInteractor
    def call
      context.little_url = LittleUrl.friendly.find(context.id)
    end
  end
end
