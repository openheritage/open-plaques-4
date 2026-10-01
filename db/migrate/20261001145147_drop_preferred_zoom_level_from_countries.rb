class DropPreferredZoomLevelFromCountries < ActiveRecord::Migration[8.1]
  def change
    remove_column :countries, :preferred_zoom_level
  end
end
