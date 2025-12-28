class DropPicks < ActiveRecord::Migration[8.1]
  def change
    drop_table :picks
  end
end
