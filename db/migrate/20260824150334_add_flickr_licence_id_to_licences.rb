class AddFlickrLicenceIdToLicences < ActiveRecord::Migration[8.1]
  def change
    add_column :licences, :flickr_licence_id, :integer
  end
end
