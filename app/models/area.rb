# frozen_string_literal: true

# <rails-lens:schema:begin>
# table = "areas"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "name", type = "string" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "dbpedia_uri", type = "string" },
#   { name = "country_id", type = "integer" },
#   { name = "slug", type = "string" },
#   { name = "latitude", type = "float" },
#   { name = "longitude", type = "float" },
#   { name = "plaques_count", type = "integer" },
#   { name = "max_latitude", type = "float" },
#   { name = "max_longitude", type = "float" },
#   { name = "min_latitude", type = "float" },
#   { name = "min_longitude", type = "float" }
# ]
#
# indexes = [
#   { name = "index_areas_on_country_id", columns = ["country_id"] },
#   { name = "index_areas_on_name", columns = ["name"] },
#   { name = "index_areas_on_slug", columns = ["slug"] }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# [callbacks]
# before_validation = [{ method = "make_slug_not_war" }]
#
# notes = ["country_id:FK_CONSTRAINT", "google_analytics:N_PLUS_ONE", "plaques:N_PLUS_ONE", "name:NOT_NULL", "dbpedia_uri:NOT_NULL", "slug:NOT_NULL", "latitude:NOT_NULL", "longitude:NOT_NULL", "plaques_count:NOT_NULL", "max_latitude:NOT_NULL", "max_longitude:NOT_NULL", "min_latitude:NOT_NULL", "min_longitude:NOT_NULL"]
# <rails-lens:schema:end>
# The largest commonly identified region of residence below a country level.
# By this, we mean the place that people would normally name in answer to the
# question of "where do you live?"".
# In most cases, this will be either a city (eg "London"), town (eg "Margate"),
# or village.
# It should not normally be either a state, county, district or other
# administrative region.
class Area < ApplicationRecord
  include ApplicationHelper
  include Geolocatable
  include PlaquesHelper

  belongs_to :country, counter_cache: true
  has_many :plaques, dependent: :restrict_with_error
  delegate :alpha2, to: :country, prefix: true
  before_validation :make_slug_not_war
  validates_presence_of :name, :slug, :country_id
  validates_uniqueness_of :slug, scope: :country_id
  scope :county, ->(name) { where("name ILIKE ?", "%, #{name}, %") }

  def alpha2
    case state
    when "England"
      "gb-eng"
    when "Scotland"
      "gb-sct"
    when "Wales"
      "gb-wls"
    when "Northern Ireland"
      "gb-nir"
    else
      country.alpha2
    end
  end

  def as_json(options = nil)
    if !options || !options[:only]
      options = {
        only: %i[name plaques_count],
        include: {
          country: {
            only: [ :name ],
            methods: :uri
          }
        },
        methods: %i[plaques_uri uri]
      }
    end
    super options
  end

  def county
    return unless name.include?(", ") && name.split(", ").size == 3

    name.split(", ")[1]
  end

  def full_name
    "#{name}, #{country.name}"
  end

  def main_photo
    random_plaque = plaques.photographed.random
    random_plaque == [] ? nil : random_plaque&.main_photo
  end

  def name=(name)
    write_attribute(:name, name.try(:squish))
  end

  def people
    people = []
    plaques.each do |plaque|
      next if plaque.people.nil?

      plaque.people.each do |person|
        people << person
      end
    end
    people.uniq
  end

  def plaques_uri
    return nil unless id && country

    path = Rails.application.routes.url_helpers.country_area_plaques_path(
      country, self, format: :json
    )
    "https://openplaques.org#{path}"
  end

  # Country.uk.areas.select { |a| a.county.nil? }.each { |a| a.update(name: a.query_county) }
  def query_county
    api = "https://services1.arcgis.com/ESMARspQHYMw9BZ9/ArcGIS/rest/services/Counties_and_Unitary_Authorities_December_2025_Boundaries_UK_BFE/FeatureServer/0/query?geometry=#{esri_geometry}&geometryType=#{esri_geometry_type}&inSR=4326&spatialRel=esriSpatialRelIntersects&outFields=*&returnGeometry=false&returnIdsOnly=false&f=pgeojson"
    response = URI.parse(api).open
    resp = response.read
    json = JSON.parse(resp)
    return if json["features"].nil? || json["features"].count.zero?

    county_name = json["features"][0]["properties"]["CTYUA25NM"]
    "#{town}, #{county_name}, #{state}"
  end

  def state
    return unless name.include?(", ")

    name.split(", ").last
  end

  def town
    return name unless name.include?(", ")

    name.split(", ").first
  end

  def to_param
    slug
  end

  def to_s
    name
  end

  def uri
    return nil unless id && country

    path = Rails.application.routes.url_helpers.country_area_path(
      country, self, format: :json
    )
    "https://openplaques.org#{path}"
  end
end
