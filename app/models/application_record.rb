class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :random, -> { order(Arel.sql("random()")).limit(1).first }
end
