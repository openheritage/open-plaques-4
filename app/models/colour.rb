# The main colour (or physical attribute) of a plaque
# === Attributes
# * +common+ - whether this is a commonly used colour
# * +dbpedia_uri+ - uri to link to DBPedia record
# * +name+ - the colour's common name (eg 'blue').
# * +plaques_count+ - cached count of plaques
# * +slug+ - textual identifier, usually equivalent to its name in lower case, with spaces replaced by underscores. Used in URLs.
class Colour < ApplicationRecord
  include ApplicationHelper # for help with making slugs

  has_many :plaques
  before_validation :make_slug_not_war
  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :slug
  scope :common, -> { where(common: true) }
  scope :uncommon, -> { where(common: false) }
  scope :by_popularity, -> { order("plaques_count desc nulls last") }

  def to_param
    slug
  end

  def to_s
    name
  end

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
end
