class AddEnglishWikipediaUrlToPeople < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :en_wikipedia_url, :string
  end
end
