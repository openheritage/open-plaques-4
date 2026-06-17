class AddNameToTodoItem < ActiveRecord::Migration[8.1]
  def self.up
    add_column :todo_items, :name, :string
    change_column :todo_items, :description, :text
    change_column :todo_items, :url, :text
  end

  def self.down
    remove_column :todo_items, :name, :string
    change_column :todo_items, :description, :string
    change_column :todo_items, :url, :string
  end
end
