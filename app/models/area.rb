# frozen_string_literal: true

# The largest commonly identified region of residence below a country level.
# By this, we mean the place that people would normally name in answer to the
# question of "where do you live?"".
# In most cases, this will be either a city (eg "London"), town (eg "Margate"),
# or village.
# It should not normally be either a state, county, district or other
# administrative region.
# === Attributes
# * +dbpedia_uri+ - uri to link to DBPedia record
# * +latitude+ - location
# * +longitude+ - location
# * +name+ - the area's common name (not neccessarily "official")
# * +plaques_count+ - cached count of plaques
# * +slug+ - a textual identifier, usually equivalent to its name in lower case,
#            with spaces replaced by underscores. Used in URLs.
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
