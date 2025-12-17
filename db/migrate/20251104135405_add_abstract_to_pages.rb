class AddAbstractToPages < ActiveRecord::Migration[8.1]
  def change
    add_column :pages, :abstract, :text
    add_reference :pages, :author, foreign_key: { to_table: :users }
    add_column :users, :biography, :text
    add_column :users, :photo_uri, :string
    add_column :users, :instagram, :string
    add_column :users, :mastodon, :string
    add_column :users, :bluesky, :string
    add_column :users, :linkedin, :string
    add_column :users, :twitter, :string
    add_column :users, :facebook, :string
  end
end
