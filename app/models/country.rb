# <rails-lens:schema:begin>
# table = "countries"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "name", type = "string" },
#   { name = "alpha2", type = "string" },
#   { name = "areas_count", type = "integer" },
#   { name = "plaques_count", type = "integer" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "description", type = "text" },
#   { name = "latitude", type = "float" },
#   { name = "longitude", type = "float" },
#   { name = "preferred_zoom_level", type = "integer" },
#   { name = "wikidata_id", type = "string" },
#   { name = "max_latitude", type = "float" },
#   { name = "max_longitude", type = "float" },
#   { name = "min_latitude", type = "float" },
#   { name = "min_longitude", type = "float" }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# notes = ["google_analytics:N_PLUS_ONE", "areas:N_PLUS_ONE", "plaques:N_PLUS_ONE", "name:NOT_NULL", "alpha2:NOT_NULL", "areas_count:NOT_NULL", "plaques_count:NOT_NULL", "description:NOT_NULL", "latitude:NOT_NULL", "longitude:NOT_NULL", "preferred_zoom_level:NOT_NULL", "max_latitude:NOT_NULL", "max_longitude:NOT_NULL", "min_latitude:NOT_NULL", "min_longitude:NOT_NULL", "wikidata_id:LIMIT", "description:STORAGE"]
# <rails-lens:schema:end>


# A top-level region definition as defined by the ISO country codes specification.
# === Attributes
# * +alpha2+ - 2-letter ISO standard code. Used in URLs.
# * +areas_count+ - cached count of areas
# * +description+ - commentary on how this region commemorates subjects
# * +latitude+ - location
# * +longitude+ - location
# * +name+ - the country's common name (not necessarily its official one).
# * +wikidata_id+ - Q-code to match to Wikidata
class Country < ApplicationRecord
  include Geolocatable
  include Nameable
  include PlaquesHelper

  has_many :areas
  has_many :plaques, through: :areas
  validates_presence_of :name, :alpha2
  validates_uniqueness_of :name, :alpha2
  scope :uk, -> { where(alpha2: "gb").first }

  def as_json(options = {})
    if !options || !options[:only]
      options = {
        only: [ :name ],
        methods: %i[uri plaques_count areas_count]
      }
    end
    super options
  end

  def name=(name)
    write_attribute(:name, name.try(:squish))
  end

  def plaques_count
    @plaques_count ||= areas.sum(:plaques_count)
  end

  def to_param
    alpha2
  end

  def to_s
    name || ""
  end

  def uri
    "https://openplaques.org#{Rails.application.routes.url_helpers.country_path(self, format: :json)}" if id
  end

  def zoom
    preferred_zoom_level || 6
  end
end
