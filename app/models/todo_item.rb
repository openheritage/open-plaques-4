# <rails-lens:schema:begin>
# table = "todo_items"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "description", type = "text" },
#   { name = "action", type = "string" },
#   { name = "url", type = "text" },
#   { name = "image_url", type = "string" },
#   { name = "plaque_id", type = "integer" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "name", type = "string" }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# notes = ["google_analytics:N_PLUS_ONE", "description:NOT_NULL", "action:NOT_NULL", "url:NOT_NULL", "image_url:NOT_NULL", "name:NOT_NULL", "name:LIMIT", "description:STORAGE", "url:STORAGE"]
# <rails-lens:schema:end>


# This class represents a todo item.
# a description, a user (who completed the task)
# an optional plaque that needs something doing to it
# an optional url for more details (e.g. a news article about an unveiling)
# and optional image url to show in the to do lists
class TodoItem < ApplicationRecord
  validates_presence_of :action, :description
  scope :google_alerts, -> { where(action: "google_alert") }
  scope :to_add, -> { where(action: "add").where.not(url: nil) }
  scope :to_datacapture, -> { where(action: "datacapture") }

  def to_datacapture?
    action == "datacapture"
  end
end
