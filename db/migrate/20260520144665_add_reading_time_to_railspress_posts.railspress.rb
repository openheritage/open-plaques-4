# This migration comes from railspress (originally 20241218000010)
class AddReadingTimeToRailspressPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :railspress_posts, :reading_time, :integer
  end
end
