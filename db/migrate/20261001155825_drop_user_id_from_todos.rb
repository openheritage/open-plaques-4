class DropUserIdFromTodos < ActiveRecord::Migration[8.1]
  def change
    remove_column :todo_items, :user_id
  end
end
