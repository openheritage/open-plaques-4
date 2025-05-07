class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include Nameable

  has_many :google_analytics, as: :record
  scope :random, ->(l = 1) { l > 1 ? order(Arel.sql("random()")).limit(l) : order(Arel.sql("random()")).limit(l).first }
end
