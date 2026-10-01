# <rails-lens:schema:begin>
# table = "organisations"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "name", type = "string" },
#   { name = "website", type = "string" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "notes", type = "text" },
#   { name = "slug", type = "string" },
#   { name = "description", type = "text" },
#   { name = "sponsorships_count", type = "integer", default = "0" },
#   { name = "latitude", type = "float" },
#   { name = "longitude", type = "float" },
#   { name = "language_id", type = "integer" },
#   { name = "max_latitude", type = "float" },
#   { name = "max_longitude", type = "float" },
#   { name = "min_latitude", type = "float" },
#   { name = "min_longitude", type = "float" },
#   { name = "wikidata_id", type = "string" },
#   { name = "en_wikipedia_url", type = "string" }
# ]
#
# indexes = [
#   { name = "index_organisations_on_name", columns = ["name"] },
#   { name = "index_organisations_on_slug", columns = ["slug"] }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# [callbacks]
# before_validation = [{ method = "make_slug_not_war" }]
#
# notes = ["language_id:INDEX", "language_id:FK_CONSTRAINT", "google_analytics:N_PLUS_ONE", "sponsorships:N_PLUS_ONE", "plaques:N_PLUS_ONE", "name:NOT_NULL", "website:NOT_NULL", "notes:NOT_NULL", "slug:NOT_NULL", "description:NOT_NULL", "sponsorships_count:NOT_NULL", "latitude:NOT_NULL", "longitude:NOT_NULL", "max_latitude:NOT_NULL", "max_longitude:NOT_NULL", "min_latitude:NOT_NULL", "min_longitude:NOT_NULL", "en_wikipedia_url:NOT_NULL", "wikidata_id:LIMIT", "en_wikipedia_url:LIMIT", "notes:STORAGE", "description:STORAGE"]
# <rails-lens:schema:end>


# An organisation involved in erecting commemorative plaques.
# Famous examples include English Heritage, civic societies or local councils.
class Organisation < ApplicationRecord
  include Geolocatable

  has_many :sponsorships, dependent: :restrict_with_error
  has_many :plaques, through: :sponsorships
  belongs_to :language, optional: true
  before_validation :make_slug_not_war
  validates_presence_of :name, :slug
  validates_uniqueness_of :slug
  validates :name, exclusion: {
    in: %w[unknown unkown Unknown],
    message: "just leave it blank"
  }
  scope :by_popularity, -> { order(sponsorships_count: :desc) }

  # for slug helper
  include ApplicationHelper

  def as_json(options = nil)
    if !options || !options[:only]
      options = {
        only: [ :name ],
        methods: %i[uri plaques_count plaques_uri]
      }
    end
    super options
  end

  def main_photo
    random_plaque = plaques.photographed.random
    random_plaque == [] ? nil : random_plaque&.main_photo
  end

  def plaques_count
    sponsorships_count
  end

  def plaques_uri
    "https://openplaques.org#{Rails.application.routes.url_helpers.organisation_plaques_path(slug, format: :geojson)}"
  end

  def to_param
    slug
  end

  def to_s
    name
  end

  def uri
    "https://openplaques.org#{Rails.application.routes.url_helpers.organisation_path(slug, format: :json)}"
  end

  def wikidata_url
    "https://www.wikidata.org/wiki/#{wikidata_id}" unless wikidata_id.blank? || wikidata_id == "Q"
  end
end
