# <rails-lens:schema:begin>
# table = "licences"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "name", type = "string" },
#   { name = "url", type = "string" },
#   { name = "allows_commercial_use", type = "boolean" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "photos_count", type = "integer" },
#   { name = "abbreviation", type = "string" },
#   { name = "flickr_licence_id", type = "integer" }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# notes = ["google_analytics:N_PLUS_ONE", "photos:N_PLUS_ONE", "name:NOT_NULL", "url:NOT_NULL", "allows_commercial_use:NOT_NULL", "photos_count:NOT_NULL", "abbreviation:NOT_NULL", "allows_commercial_use:DEFAULT"]
# <rails-lens:schema:end>


# A content licence, such as those produced by the Creative Commons organisation
class Licence < ApplicationRecord
  has_many :photos
  validates_presence_of :name, :url
  validates_uniqueness_of :url

  def as_json(options = {})
    if !options || !options[:only]
      options = {
        only: %i[name abbreviation url allows_commercial_reuse photos_count]
      }
    end
    super options
  end

  # technically, this returns the starting index but can be treated as boolean
  def creative_commons?
    url =~ %r{creativecommons.org/licenses}i
  end

  def to_s
    name
  end
end
