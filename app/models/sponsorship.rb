# <rails-lens:schema:begin>
# table = "sponsorships"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "organisation_id", type = "integer" },
#   { name = "plaque_id", type = "integer" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" }
# ]
#
# indexes = [
#   { name = "index_sponsorships_on_organisation_id", columns = ["organisation_id"] },
#   { name = "index_sponsorships_on_plaque_id", columns = ["plaque_id"] }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# notes = ["plaque_id:FK_CONSTRAINT", "organisation_id:FK_CONSTRAINT", "google_analytics:N_PLUS_ONE"]
# <rails-lens:schema:end>


# A provision of funds or permission to erect a commemorative plaque
# such that the organisation often has its name displayed on the plaque
class Sponsorship < ApplicationRecord
  belongs_to :plaque
  belongs_to :organisation, counter_cache: true
end
