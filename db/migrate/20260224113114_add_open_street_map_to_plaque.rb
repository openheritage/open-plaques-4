class AddOpenStreetMapToPlaque < ActiveRecord::Migration[8.1]
  def change
    add_column :plaques, :openstreetmap, :string
  end
end
