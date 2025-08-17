module LittleUrls
  class SetCreatorId < ApplicationInteractor
    def call
      cookies = context.cookies
      
      cookies.permanent.signed[:creator_id] ||= SecureRandom.uuid
      context.creator_id = cookies.signed[:creator_id]
    end
  end
end
