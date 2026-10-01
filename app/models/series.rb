# <rails-lens:schema:begin>
# table = "series"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "name", type = "string" },
#   { name = "description", type = "string" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "plaques_count", type = "integer" },
#   { name = "latitude", type = "float" },
#   { name = "longitude", type = "float" },
#   { name = "max_latitude", type = "float" },
#   { name = "max_longitude", type = "float" },
#   { name = "min_latitude", type = "float" },
#   { name = "min_longitude", type = "float" }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# notes = ["google_analytics:N_PLUS_ONE", "plaques:N_PLUS_ONE", "name:NOT_NULL", "description:NOT_NULL", "plaques_count:NOT_NULL", "latitude:NOT_NULL", "longitude:NOT_NULL", "max_latitude:NOT_NULL", "max_longitude:NOT_NULL", "min_latitude:NOT_NULL", "min_longitude:NOT_NULL"]
# <rails-lens:schema:end>


# A series of commemorative plaques
# This is normally marked on the plaque itself
class Series < ApplicationRecord
  include Geolocatable

  has_many :plaques
  validates_presence_of :name

  def as_json(options = {})
    unless options[:only]
      options = {
        only: %i[name description plaques_count],
        methods: :uri
      }
    end
    super(options)
  end

  def main_photo
    random_plaque = plaques.photographed.random
    random_plaque == [] ? nil : random_plaque&.main_photo
  end

  def to_s
    "##{id}"
  end

  def uri
    "https://openplaques.org#{Rails.application.routes.url_helpers.series_path(id, format: :json)}" if id
  end

  def zoom
    10
  end
end
