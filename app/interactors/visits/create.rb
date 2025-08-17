module Visits
  class Create < ApplicationOrganizer
    organize LittleUrls::FindObject,
             TrackVisit
  end
end
