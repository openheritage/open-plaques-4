# frozen_string_literal: true

# This migration comes from railspress (originally 20260206000001)
class CreateRailspressContentGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :railspress_content_groups do |t|
      t.string :name, null: false
      t.text :description
      t.bigint :author_id
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :railspress_content_groups, :name, unique: true
    add_index :railspress_content_groups, :deleted_at
    add_index :railspress_content_groups, :author_id
  end
end
