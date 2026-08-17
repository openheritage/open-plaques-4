class DropPages < ActiveRecord::Migration[8.1]
  def change
    drop_table :pages
  end
end
