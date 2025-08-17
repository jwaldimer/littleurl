module LittleUrls
  class Delete < ApplicationOrganizer
    organize FindObject,
             Authorize,
             Destroy
  end
end