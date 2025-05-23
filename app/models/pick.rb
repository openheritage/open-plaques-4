# A featured plaque, e.g. 'plaque of the day'
# It should hold enough information to be able to rotate the plaque featured
# on the home page to something topical and/or interesting
# === Attributes
# * +description+ - a short blurb on why this one was chosen
# * +featured_count+ - number of times the plaque has been featured
# * +feature_on+ - (optional) a specific date to show this plaque, e.g. someone's birthday
# * +last_featured+ - when the plaque was last featured
# * +proposer+ - person who proposed it
class Pick < ApplicationRecord
  belongs_to :plaque
  validates_presence_of :plaque_id
  validates_uniqueness_of :plaque_id
  scope :current, lambda {
    where(
      [
        "last_featured > ? and last_featured < ?",
        "#{(Date.today - 1.day).strftime} 23:59:59 UTC",
        "#{(Date.today + 1.day).strftime} 00:00:00 UTC"
      ]
    )
      .order(last_featured: :desc)
  }
  scope :never_been_featured, lambda {
    where([ "last_featured is null or featured_count = 0 or featured_count is null" ])
  }
  scope :preferably_today, lambda {
    where(
      [
        "feature_on > ? and feature_on < ?",
        "#{(Date.today - 1.day).strftime} 23:59:59 UTC",
        "#{(Date.today + 1.day).strftime} 00:00:00 UTC"
      ]
    )
      .order(featured_count: :asc)
  }
  scope :least_featured, lambda {
    where([ "last_featured < ?", Date.today - 1.week ])
      .order(featured_count: :asc)
  }

  def self.todays
    rotate unless Pick.current.first
    @todays = Pick.current.first
  end

  def self.rotate
    @todays = Pick.preferably_today.first
    @todays = Pick.never_been_featured.first if @todays.nil?
    @todays = Pick.least_featured.first if @todays.nil?
    return unless @todays

    @todays.choose
    @todays.save
  end

  def choose
    self.last_featured = DateTime.now
    self.featured_count = 0 if featured_count.nil?
    self.featured_count = featured_count + 1
  end

  def title
    "Pick ##{id} #{plaque.title}"
  end

  def longitude
    plaque.longitude
  end

  def latitude
    plaque.latitude
  end

  def photo
    plaque.main_photo
  end

  def as_json(options = {})
    if !options || !options[:only]
      options = {
        only: %i[description featured_count proposer last_featured],
        include: {
          plaque: { only: [], methods: [ :uri ] }
        },
        methods: [ :title ]
      }
    end
    super options
  end
end
