class MatchOsmTexas
  include Interactor

  def call
    # bottom_left = "-101.96870326995851,31.20454285891723"
    # top_right = "-101.90643310546876,31.23782978410905"
    bottom_left = "-114.47839,21.33031"
    top_right = "-82.59607,38.49659"
    bbox = "ST_SetSRID(ST_MakeBox2D(ST_Point(#{bottom_left}), ST_Point(#{top_right})), 4326)"
    q = "SELECT osm_id, tags, geom FROM postpass_point WHERE tags ? 'ref:US-TX:thc' AND geom && #{bbox}"
    api = "https://postpass.geofabrik.de/api/interpreter?data=#{q.gsub("&", "%26").gsub("?", "%3F").gsub(":", "%3A")}"
    response = URI.parse(api).open
    resp = response.read
    geojson = JSON.parse(resp)
    geojson["features"].each do |feature|
      tags = feature["properties"]["tags"]
      plaque = Plaque.find_by(series_id: 42, series_ref: tags["ref:US-TX:thc"].rjust(5, "0"))
      next unless plaque && plaque.openstreetmap.blank?

      puts plaque.id
      if tags.has_key?("start_date") && plaque.erected_at.blank?
        erected_at_string = tags["start_date"]
        puts erected_at_string
        plaque.update!(erected_at_string:)
      end
      if tags.has_key?("addr:full") && (plaque.address.blank? || plaque.address == "?")
        address = tags["addr:full"]
        puts address
        plaque.update!(address:)
      end
      openstreetmap = feature["properties"]["osm_id"]
      plaque.update!(openstreetmap:)
    end
  end
end
