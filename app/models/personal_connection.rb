# A commemoration of a subject on a plaque. This acts as a 'join' between the two.
# === Attributes
# * +ended_at+ - when the subject stopped doing what they did at the place
# * +started_at+ - when the subject started doing what they did at the place
# * +plaque_connections_count+ - Cached count of plaques
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
