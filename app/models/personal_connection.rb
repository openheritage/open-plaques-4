# <rails-lens:schema:begin>
# table = "personal_connections"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "person_id", type = "integer" },
#   { name = "verb_id", type = "integer" },
#   { name = "plaque_id", type = "integer" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "started_at", type = "datetime" },
#   { name = "ended_at", type = "datetime" },
#   { name = "plaque_connections_count", type = "integer" }
# ]
#
# indexes = [
#   { name = "index_personal_connections_on_person_id", columns = ["person_id"] },
#   { name = "index_personal_connections_on_plaque_id", columns = ["plaque_id"] },
#   { name = "index_personal_connections_on_verb_id", columns = ["verb_id"] }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# [callbacks]
# after_commit = [{ method = "notify_slack" }]
#
# notes = ["person_id:FK_CONSTRAINT", "plaque_id:FK_CONSTRAINT", "verb_id:FK_CONSTRAINT", "google_analytics:N_PLUS_ONE", "plaque_connections_count:NOT_NULL"]
# <rails-lens:schema:end>


# A commemoration of a subject on a plaque. This acts as a join between the two.
class PersonalConnection < ApplicationRecord
  belongs_to :person, counter_cache: true
  belongs_to :plaque, counter_cache: true
  belongs_to :verb, counter_cache: true
  validates_presence_of :verb_id, :person_id, :plaque_id
  after_commit :notify_slack, on: :create
  attr_accessor :other_verb_id

  # this would be a Verb query, but data is fixed and this is used frequently
  def birth?
    [ 8, 504 ].include?(verb.id)
  end

  # this would be a Verb query, but data is fixed and this is used frequently
  def death?
    [ 3, 49, 161, 288, 292, 566, 779, 1103, 1108, 1147 ].include?(verb.id)
  end

  def from
    year = started_at ? started_at.year.to_s : ""
    year = person.born_in.to_s if birth?
    year = person.died_in.to_s if death?
    year
  end

  def full_address
    plaque&.full_address
  end

  def notify_slack
    return unless Rails.env.production?

    hook = ENV.fetch("SLACKHOOK", "")
    return if hook.empty?

    notifier = Slack::Notifier.new(hook)
    phrase = [ "someone just connected", "there is a new connection from", "new connection alert!" ].sample
    notifier.ping "#{phrase} <a href='#{person.uri}'>#{person.name_and_dates}</a> to <a href='#{plaque.uri}'>#{plaque.inscription_preferably_in_english}</a>"
  end

  def single_year?
    from == to
  end

  # suggest subjects for a plaque
  def suggestions
    suggested_people = []
    entities = []
    begin
      client = Aws::Comprehend::Client.new(region: "eu-west-1")
      result = client.detect_entities(
        { text: plaque.inscription_preferably_in_english, language_code: :en }
      )
      entities = result["entities"]
    rescue
      Rails.logger.error("Unable to call AWS Comprehend. Maybe env credentials are wrong.")
    end

    entities.each_with_index do |ent, i|
      Rails.logger.debug(ent)
      next unless ent.type == "PERSON" || ent.type == "ORGANIZATION"

      term = ent.text
      term += " #{entities[i + 1].text}" if entities[i + 1]&.type == "DATE" # plus, it could already be a range
      term += "-#{entities[i + 2].text}" if entities[i + 2]&.type == "DATE"
      search_result = Person.search(term)
      suggested_people += search_result if search_result
    end
    Rails.logger.debug("suggestions #{suggested_people}")
    return suggested_people, entities
  end

  def to
    year = ended_at ? ended_at.year.to_s : ""
    year = person.born_in.to_s if birth?
    year = person.died_in.to_s if death?
    year
  end
end
