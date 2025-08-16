module LittleUrls
  class Create < ApplicationOrganizer
    organize NormalizeParams,
             SetCreatorId,
             BuildNew,
             Save
  end
end
