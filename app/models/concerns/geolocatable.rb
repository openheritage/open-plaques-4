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
  
  def esri_geometry
    "#{longitude},#{latitude}"
  end

  def esri_geometry_type
    point? ? 'esriGeometryPoint' : 'esriGeometryPolygon'
  end

  def point?
    true
  end

  # given a set of plaques, or is a thing that has plaques (like an organisation) tell me what the mean point is
  def geolocate!(things = nil)
    things ||= self.plaques.geolocated
    return unless things.any?

    update!(
      latitude: things.average(:latitude).round(5),
      longitude: things.average(:longitude).round(5)
    )
    return unless respond_to?(:min_latitude)

    tolerance = 0.003
    if things.maximum(:latitude) - things.minimum(:latitude) > tolerance
      update!(
        min_latitude: things.minimum(:latitude).round(5),
        min_longitude: things.minimum(:longitude).round(5),
        max_latitude: things.maximum(:latitude).round(5),
        max_longitude: things.maximum(:longitude).round(5)
      )
    else
      update!(
        min_latitude: (things.average(:latitude) - (tolerance / 2)).round(5),
        min_longitude: (things.average(:longitude) - (tolerance / 2)).round(5),
        max_latitude: (things.average(:latitude) + (tolerance / 2)).round(5),
        max_longitude: (things.average(:longitude) + (tolerance / 2)).round(5)
      )
    end
  end

  def geolocated?
    !(latitude.nil? || longitude.nil? || latitude == 51.475 && longitude.zero?)
  end
end

# A geographic point location
# class Point
#   attr_accessor :latitude, :longitude, :precision, :zoom
# end
