class RenameLatLonColumns < ActiveRecord::Migration[8.1]
  def change
    add_column :areas, :max_latitude, :float
    add_column :areas, :max_longitude, :float
    add_column :areas, :min_latitude, :float
    add_column :areas, :min_longitude, :float

    add_column :countries, :max_latitude, :float
    add_column :countries, :max_longitude, :float
    add_column :countries, :min_latitude, :float
    add_column :countries, :min_longitude, :float

    add_column :languages, :latitude, :float
    add_column :languages, :longitude, :float
    add_column :languages, :max_latitude, :float
    add_column :languages, :max_longitude, :float
    add_column :languages, :min_latitude, :float
    add_column :languages, :min_longitude, :float

    add_column :organisations, :max_latitude, :float
    add_column :organisations, :max_longitude, :float
    add_column :organisations, :min_latitude, :float
    add_column :organisations, :min_longitude, :float

    add_column :pages, :latitude, :float
    add_column :pages, :longitude, :float
    add_column :pages, :max_latitude, :float
    add_column :pages, :max_longitude, :float
    add_column :pages, :min_latitude, :float
    add_column :pages, :min_longitude, :float

    add_column :people, :latitude, :float
    add_column :people, :longitude, :float
    add_column :people, :max_latitude, :float
    add_column :people, :max_longitude, :float
    add_column :people, :min_latitude, :float
    add_column :people, :min_longitude, :float

    add_column :series, :max_latitude, :float
    add_column :series, :max_longitude, :float
    add_column :series, :min_latitude, :float
    add_column :series, :min_longitude, :float
  end
end
