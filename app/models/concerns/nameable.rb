# has a 'name' attribute
module Nameable
  extend ActiveSupport::Concern

  included do
    scope :alphabetically, -> { order("name ASC nulls last") }
    scope :name_starts_with, ->(term) { where([ "name ILIKE ?", "#{term}%" ]) }
    scope :name_contains, ->(term) { where([ "name ILIKE ?", "%#{term}%" ]) }
    scope :name_is, ->(term) { where([ "lower(name) = ?", term.to_s.downcase ]) }
  end
end
