class AddEnWikipediaUrlToRoles < ActiveRecord::Migration[8.1]
  def change
    add_column :roles, :en_wikipedia_url, :string
  end
end
