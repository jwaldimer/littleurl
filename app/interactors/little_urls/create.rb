module LittleUrls
  class Create < ApplicationOrganizer
    organize NormalizeParams,
             SetCreatorId,
             Build,
             Save
  end
end
