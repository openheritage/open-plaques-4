# <rails-lens:schema:begin>
# table = "google_analytics"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "page", type = "string", null = false },
#   { name = "period", type = "string", null = false },
#   { name = "record_type", type = "string", null = false },
#   { name = "record_id", type = "integer", null = false },
#   { name = "page_views", type = "integer", null = false },
#   { name = "unique_page_views", type = "integer" },
#   { name = "average_time_on_page", type = "float" },
#   { name = "entrances", type = "integer" },
#   { name = "bounce_rate", type = "float" },
#   { name = "exit_percentage", type = "float" },
#   { name = "created_at", type = "datetime", null = false }
# ]
#
# indexes = [
#   { name = "index_ga_uniqueness", columns = ["record_type", "record_id", "page", "period"], unique = true }
# ]
#
# [polymorphic]
# references = [{ name = "record", type_col = "record_type", id_col = "record_id", types = ["Plaque"] }]
# targets = [{ name = "google_analytics", as = "record" }]
#
# notes = ["record:POLY_INDEX", "google_analytics:N_PLUS_ONE", "unique_page_views:NOT_NULL", "average_time_on_page:NOT_NULL", "entrances:NOT_NULL", "bounce_rate:NOT_NULL", "exit_percentage:NOT_NULL", "page:LIMIT", "period:LIMIT", "record_type:LIMIT", "bounce_rate:USE_DECIMAL", "NO_TIMESTAMPS", "PARTIAL_TS"]
# <rails-lens:schema:end>


class GoogleAnalytic < ApplicationRecord
  belongs_to :record, polymorphic: true, touch: true
end
