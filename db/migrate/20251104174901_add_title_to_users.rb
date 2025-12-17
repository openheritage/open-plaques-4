class AddTitleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :title, :string
  end
end
