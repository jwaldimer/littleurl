module LittleUrls
  class Update < ApplicationOrganizer
    organize NormalizeParams,
             BuildEdit,
             Save
  end
end
