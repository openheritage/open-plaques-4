# A page of text from a very simple CMS
# === Attributes
# * +body+ - The content
# * +name+ - The name of the page
# * +slug+ - An identifier for the organisation, usually equivalent to its name in lower case, with spaces replaced by underscores. Used in URLs.
# * +strapline+ - A sub heading
# * +view_count+ - Total number of views
# * +recent_view_count+ - Number of views in last period
# * +recent_view_count_start+ - Date the last period count was started from
class Page < ApplicationRecord
  include ApplicationHelper

  belongs_to :author, class_name: "User", optional: true
  acts_as_taggable_on :categories
  acts_as_taggable_on :tags
  before_validation :make_slug_not_war
  validates_presence_of :name, :slug, :body
  validates_uniqueness_of :slug
  validates_format_of :slug, with: /\A[a-z_]+\z/, message: "can only contain lowercase letters and underscores"

  def category
    %w[project favourites culture].sample
  end

  def main_photo
    matches = /plaque #(\d*)/.match(body)
    matches ? Plaque.find(matches[1]).main_photo : nil
  end

  def to_s
    name
  end
end
