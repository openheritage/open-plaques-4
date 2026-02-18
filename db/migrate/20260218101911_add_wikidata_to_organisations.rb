class AddWikidataToOrganisations < ActiveRecord::Migration[8.1]
  def change
    add_column :organisations, :wikidata_id, :string
    add_column :organisations, :en_wikipedia_url, :string
  end
end
