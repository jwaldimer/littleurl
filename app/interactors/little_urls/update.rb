module LittleUrls
  class Update < ApplicationOrganizer
    organize FindObject,
             NormalizeParams,
             BuildEdit,
             Save
  end
end
