class MatchOsm
  include Interactor

  def call
    q = "SELECT osm_id, tags, geom FROM postpass_point WHERE tags ? 'openplaques:id'"
    api = "https://postpass.geofabrik.de/api/interpreter?data=#{q.gsub("&", "%26").gsub("?", "%3F").gsub(":", "%3A")}"
    response = URI.parse(api).open
    resp = response.read
    geojson = JSON.parse(resp)
    geojson["features"].each do |feature|
      tags = feature["properties"]["tags"]
      Rails.logger.debug(tags)
      plaque = Plaque.find(tags["openplaques:id"])
      next unless plaque && plaque.openstreetmap.blank?

      if tags.has_key?("start_date") && plaque.erected_at.blank?
        erected_at_string = tags["start_date"]
        plaque.update!(erected_at_string:)
      end
      if tags.has_key?("addr:full") && (plaque.address.blank? || plaque.address == "?")
        address = tags["addr:full"]
        plaque.update!(address:)
      end
      openstreetmap = feature["properties"]["osm_id"]
      plaque.update!(openstreetmap:)
    end
  end
end
