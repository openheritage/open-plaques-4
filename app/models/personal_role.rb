# <rails-lens:schema:begin>
# table = "personal_roles"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "person_id", type = "integer" },
#   { name = "role_id", type = "integer" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "started_at", type = "date" },
#   { name = "ended_at", type = "date" },
#   { name = "related_person_id", type = "integer" },
#   { name = "ordinal", type = "integer" },
#   { name = "primary", type = "boolean" }
# ]
#
# indexes = [
#   { name = "index_personal_roles_on_person_id", columns = ["person_id"] },
#   { name = "index_personal_roles_on_related_person_id", columns = ["related_person_id"] },
#   { name = "index_personal_roles_on_role_id", columns = ["role_id"] }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# notes = ["person_id+related_person_id:COMP_INDEX", "person_id:FK_CONSTRAINT", "related_person_id:FK_CONSTRAINT", "role_id:FK_CONSTRAINT", "related_person:INVERSE_OF", "google_analytics:N_PLUS_ONE", "ordinal:NOT_NULL", "primary:NOT_NULL", "primary:DEFAULT"]
# <rails-lens:schema:end>


# A connection between a subject and a role.
class PersonalRole < ApplicationRecord
  belongs_to :person, counter_cache: true
  belongs_to :related_person, class_name: "Person", optional: true
  belongs_to :role, counter_cache: true
  validates_presence_of :person_id, :role_id
  scope :by_date, -> { order(:started_at) }

  def current?
    role.sticky? || ended_at.nil? || ended_at == "" || (ended_at && ended_at.year.to_s == person.died_on.to_s)
  end

  def date_range
    dates = ""
    dates += "from #{started_at.to_s.sub('-01-01', '')}" if started_at
    dates += "to #{ended_at.to_s.sub('-01-01', '')}" if ended_at
    dates.strip
  end

  def name
    n = role.name
    n += " of #{related_person.name}" if related_person
    n
  end

  def primary?
    primary == true
  end

  def relationship?
    !related_person_id.nil?
  end

  def suffix
    s = role.suffix
    if s.include?('#{ordinal}')
      s = if ordinal
            s.sub!('#{ordinal}', ordinal.ordinalize)
      else
            s.sub!('#{ordinal} ', "")
      end
    end
    s
  end

  def year_range
    dates = ""
    start_year = started_at.to_s[0..3]
    dates += start_year if started_at
    end_year = ended_at.to_s[0..3]
    end_year = "" if end_year == start_year
    end_year = end_year[2..3] if end_year[0..1] == start_year[0..1]
    dates += "-#{end_year}" if end_year && end_year != ""
    dates
  end
end
