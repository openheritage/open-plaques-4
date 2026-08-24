# A content licence, such as those produced by the Creative Commons organisation
# === Attributes
# * +abbreviation+ - short name, e.g. CC BY-NC-SA 2.0
# * +allows_commercial_reuse+ - commercial usage rights
# * +name+ - the full name
# * +photos_count+ - cached count of photos
# * +url+ - a permanent URL at which the licence.
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
