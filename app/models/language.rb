# <rails-lens:schema:begin>
# table = "languages"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "name", type = "string" },
#   { name = "alpha2", type = "string" },
#   { name = "plaques_count", type = "integer" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
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
# notes = ["google_analytics:N_PLUS_ONE", "plaques:N_PLUS_ONE", "organisations:N_PLUS_ONE", "name:NOT_NULL", "alpha2:NOT_NULL", "plaques_count:NOT_NULL", "latitude:NOT_NULL", "longitude:NOT_NULL", "max_latitude:NOT_NULL", "max_longitude:NOT_NULL", "min_latitude:NOT_NULL", "min_longitude:NOT_NULL"]
# <rails-lens:schema:end>


# A natural language, as defined by the ISO code.
class Language < ApplicationRecord
  has_many :plaques
  has_many :organisations
  validates_presence_of :name, :alpha2
  validates_uniqueness_of :name, :alpha2

  def as_json(options = {})
    unless options[:prefixes].blank?
      options = {
        only: %i[name alpha2 plaques_count],
        include: {},
        methods: []
      }
    end
    super(options)
  end

  def flag_icon
    alpha = alpha2[0, 2]
    case alpha
    when "af" # Afrikaans
      alpha = "za"
    when "be" # Belarusian
      alpha = "by"
    when "ca" # Catalan
      alpha = "es-ct"
    when "cs" # Czech
      alpha = "cz"
    when "cy" # Welsh
      alpha = "gb-wls"
    when "ga" # Gaelic
      alpha = "ie"
    when "la" # Latin
      alpha = "it"
    when "uk" # Ukrainian
      alpha = "ua"
    end
    "flag-icon-#{alpha}"
  end

  def to_param
    alpha2
  end

  def to_s
    name
  end
end
