# <rails-lens:schema:begin>
# table = "roles"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "name", type = "string" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "personal_roles_count", type = "integer" },
#   { name = "index", type = "string" },
#   { name = "slug", type = "string" },
#   { name = "role_type", type = "string" },
#   { name = "abbreviation", type = "string" },
#   { name = "prefix", type = "string" },
#   { name = "suffix", type = "string" },
#   { name = "description", type = "text" },
#   { name = "priority", type = "integer" },
#   { name = "wikidata_id", type = "string" },
#   { name = "en_wikipedia_url", type = "string" }
# ]
#
# indexes = [
#   { name = "index_roles_on_role_type", columns = ["role_type"] },
#   { name = "index_roles_on_slug", columns = ["slug"] },
#   { name = "starts_with", columns = ["index"] }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# [callbacks]
# before_validation = [{ method = "make_slug_not_war" }]
# before_save = [{ method = "update_index" }, { method = "filter_name" }, { method = "fill_wikidata_id" }]
#
# notes = ["google_analytics:N_PLUS_ONE", "personal_roles:N_PLUS_ONE", "people:N_PLUS_ONE", "name:NOT_NULL", "personal_roles_count:NOT_NULL", "index:NOT_NULL", "slug:NOT_NULL", "role_type:NOT_NULL", "abbreviation:NOT_NULL", "prefix:NOT_NULL", "suffix:NOT_NULL", "description:NOT_NULL", "priority:NOT_NULL", "en_wikipedia_url:NOT_NULL", "wikidata_id:LIMIT", "en_wikipedia_url:LIMIT", "description:STORAGE"]
# <rails-lens:schema:end>


# A role ascribed to a subject.
# These can be professions (eg 'doctor'), occupations ('artist'), or activities ('inventor').
# * +wikidata_id+ - calculated Qnnnnn code, set to 'Q' if not found
class Role < ApplicationRecord
  include ApplicationHelper

  has_many :personal_roles, -> { by_date }
  has_many :people, -> { alphabetically }, through: :personal_roles
  before_validation :make_slug_not_war
  before_save :update_index
  before_save :filter_name
  before_save :fill_wikidata_id
  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :slug
  scope :by_popularity, -> { order("personal_roles_count DESC nulls last") }
  scope :name_is, ->(term) { where([ "lower(name) = ? OR lower(abbreviation) = ?", term.to_s.downcase, term.to_s.downcase ]) }

  def self.types
    [
      "person",
      "man",
      "woman",
      "animal",
      "thing",
      "group",
      "place",
      "relationship",
      "parent",
      "spouse",
      "child",
      "title",
      "letters",
      "military medal",
      "clergy"
    ]
  end

  def abbreviated?
    abbreviation.present?
  end

  def animal?
    role_type == "animal"
  end

  def as_json(options = {})
    if !options || !options[:only]
      options = {
        only: %i[name personal_roles_count role_type abbreviation],
        methods: %i[type full_name male? relationship? confers_honourific_title?]
      }
    end
    super options
  end

  def confers_honourific_title?
    [
      "Baronet", "Baroness",
      "Knight Bachelor",
      "Knight of the Order of the Garter", "Knight of the Order of the Thistle",
      "Knight Commander of the Order of the Bath", "Knight Grand Cross of the Order of the Bath",
      "Knight Commander of the Order of St Michael and St George", "Knight Grand Cross of the Order of St Michael and St George",
      "Knight Commander of the Royal Victorian Order", "Knight Grand Cross of the Royal Victorian Order",
      "Knight Commander of the Order of the British Empire", "Knight Grand Cross of the Order of the British Empire",
      "Lady"
    ].include?(name)
  end

  def dbpedia_abstract
    return description if description.present?

    return nil if dbpedia_uri.blank?

    api = "#{dbpedia_uri.gsub('resource', 'data')}.json"
    begin
      response = URI.parse(api).open
      resp = response.read
      parsed_json = JSON.parse(resp)
      abstract = parsed_json[dbpedia_uri]["http://dbpedia.org/ontology/abstract"]
      self.description = abstract.find { |txt| txt["lang"] == "en" }["value"]
    rescue
    end
  end

  def dbpedia_uri
    wikipedia_url&.gsub("en.wikipedia.org/wiki", "dbpedia.org/resource")&.gsub("https", "http")
  end

  def display_name
    abbreviated? ? abbreviation : name
  end

  def ennobled_female?
    [
      "Baroness",
      "Dame",
      "Dame Commander of the Most Excellent Order of the British Empire",
      "Dame Commander of the Royal Victorian Order",
      "Empress",
      "Lady",
      "Queen"
    ].include?(name) || name.start_with?("Viscountess")
  end

  def family?
    %w[parent child spouse].include?(role_type) || %w[brother sister half-brother half-sister].include?(name)
  end

  def female?
    role_type == "woman" ||
      %w[wife sister half-sister daughter mother].include?(name) ||
      ennobled_female? ||
      [ "Woman Police Constable" ].include?(name)
  end

  def fill_wikidata_id
    unless wikidata_id&.match(/Q\d*$/)
      self.wikidata_id = Wikidata.qcode(name)
      dbpedia_abstract
    end
    dbpedia_abstract if wikidata_id&.match(/Q\d*$/) && description.blank?
  end

  def full_name
    return "#{abbreviation} - #{name}" if abbreviated?

    name
  end

  def group?
    role_type == "group"
  end

  def letters
    used_as_a_suffix? ? suffix : ""
  end

  def male?
    !female?
  end

  def military_medal?
    role_type == "military medal"
  end

  def person?
    !(animal? || thing? || group? || place?)
  end

  def place?
    role_type == "place"
  end

  def pluralize
    if full_name.include?(" of ")
      name.split(/#| of /).first.pluralize + name.sub(/.*? of /, " of ")
    else
      name.pluralize
    end
  end

  def related_roles
    Role.where(
      [
        "lower(name) != ? and (lower(name) LIKE ? or lower(name) LIKE ? or lower(name) LIKE ? )",
        name.downcase,
        "#{name.downcase} %",
        "% #{name.downcase} %",
        "% #{name.downcase}"
      ]
    )
  end

  def relationship?
    %w[relationship parent spouse child group].include?(role_type)
  end

  def sticky?
    name == "President of the Royal Society" || prefix == "King" || prefix == "Queen"
  end

  def thing?
    role_type == "thing"
  end

  def to_s
    name
  end

  def type
    return "person" if person?

    return "animal" if animal?

    return "thing" if thing?

    return "group" if group?

    "place" if place?
  end

  def uri
    "https://openplaques.org#{Rails.application.routes.url_helpers.role_path(slug, format: :json)}"
  end

  def used_as_a_prefix?
    prefix.present?
  end

  def used_as_a_suffix?
    suffix.present?
  end

  def wikidata_url
    "https://www.wikidata.org/wiki/#{wikidata_id}" unless wikidata_id.blank? || wikidata_id == "Q"
  end

  def wikipedia_url
    return en_wikipedia_url if en_wikipedia_url

    return nil unless wikidata_id && wikidata_id != "Q" && wikidata_id != "t"

    url = Wikidata.new(wikidata_id).en_wikipedia_url
    update(en_wikipedia_url: url) if url
    en_wikipedia_url
  rescue
    # timeout?
    puts "Wikidata timeout?"
  end

  private

  def update_index
    self.index = name[0, 1].downcase
  end

  def filter_name
    self.name = name.gsub(/\.?\??/, "").strip
  end
end
