# can be geolocated
module Geolocatable
  extend ActiveSupport::Concern

  # commonly used by Mapbox/Maplibre to set map center
  def center_point_array
    [ longitude, latitude ]
  end
end
