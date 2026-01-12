# can be geolocated
module Geolocatable
  extend ActiveSupport::Concern

  # Mapbox bounding box (southwest corner, northeast corner)
  def bbox_array
    return unless respond_to?(:min_longitude) && min_longitude

    sw_corner = [ min_longitude, min_latitude ]
    ne_corner = [ max_longitude, max_latitude ]
    [ sw_corner, ne_corner ]
  end

  # commonly used by Mapbox/Maplibre to set map center
  def center_point_array
    [ longitude, latitude ]
  end

  # given a set of plaques, or is a thing that has plaques (like an organisation) tell me what the mean point is
  def geolocate!(things = nil)
    things ||= self.plaques.geolocated
    update!(latitude: things.average(:latitude), longitude: things.average(:longitude))
    update!(min_latitude: things.minimum(:latitude), min_longitude: things.minimum(:longitude), max_latitude: things.maximum(:latitude), max_longitude: things.maximum(:longitude)) if respond_to?(:min_latitude)
  end

  def geolocated?
    !(latitude.nil? || longitude.nil? || latitude == 51.475 && longitude.zero?)
  end
end

# A geographic point location
# class Point
#   attr_accessor :latitude, :longitude, :precision, :zoom
# end
