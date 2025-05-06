class AddCountryIdToAreas < ActiveRecord::Migration[4.2]
  def self.up
    add_column :areas, :country_id, :integer
  end

  def self.down
    remove_column :areas, :country_id
  end
end
