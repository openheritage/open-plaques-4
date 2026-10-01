# <rails-lens:schema:begin>
# table = "colours"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "name", type = "string" },
#   { name = "plaques_count", type = "integer" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "dbpedia_uri", type = "string" },
#   { name = "common", type = "boolean", null = false, default = "false" },
#   { name = "slug", type = "string" }
# ]
#
# indexes = [
#   { name = "index_colours_on_slug", columns = ["slug"] }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# [callbacks]
# before_validation = [{ method = "make_slug_not_war" }]
#
# notes = ["google_analytics:N_PLUS_ONE", "plaques:N_PLUS_ONE", "name:NOT_NULL", "plaques_count:NOT_NULL", "dbpedia_uri:NOT_NULL", "slug:NOT_NULL"]
# <rails-lens:schema:end>


# The main colour (or physical attribute) of a plaque
class Colour < ApplicationRecord
  include ApplicationHelper

  has_many :plaques
  before_validation :make_slug_not_war
  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :slug
  scope :common, -> { where(common: true) }
  scope :uncommon, -> { where(common: false) }

  def as_json(options = {})
    unless options[:prefixes].blank?
      options = {
        only: %i[name plaques_count common],
        include: {},
        methods: []
      }
    end
    super options
  end

  def to_param
    slug
  end

  def to_s
    name
  end
end
