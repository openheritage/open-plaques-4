# <rails-lens:schema:begin>
# table = "verbs"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "name", type = "string" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "personal_connections_count", type = "integer" }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# notes = ["google_analytics:N_PLUS_ONE", "personal_connections:N_PLUS_ONE", "people:N_PLUS_ONE", "name:NOT_NULL", "personal_connections_count:NOT_NULL"]
# <rails-lens:schema:end>


# A past-tense action connecting a subject with a location, eg 'lived', 'worked' or 'played'.
class Verb < ApplicationRecord
  has_many :personal_connections
  has_many :people, through: :personal_connections
  validates_presence_of :name
  validates_uniqueness_of :name

  def self.common
    [
      Verb.find_by(name: "was born"),
      Verb.find_by(name: "lived"),
      Verb.find_by(name: "died")
    ].compact
  end

  def as_json(options = nil)
    unless options && options[:only]
      options = {
        only: [ :name ],
        include: {
          people: { only: [ :name ], methods: [ :uri ] }
        },
        methods: [ :uri ]
      }
    end
    super(options)
  end

  def to_param
    name.gsub(/[. ]/, "_")
  end

  def to_s
    name
  end

  def uri
    "https://openplaques.org#{Rails.application.routes.url_helpers.verb_path(self, format: :json)}"
  end
end
