# <rails-lens:schema:begin>
# table = "users"
# database_dialect = "PostgreSQL"
#
# columns = [
#   { name = "id", type = "integer", pk = true, null = false },
#   { name = "username", type = "string" },
#   { name = "name", type = "string" },
#   { name = "email", type = "string" },
#   { name = "crypted_password", type = "string" },
#   { name = "salt", type = "string" },
#   { name = "created_at", type = "datetime" },
#   { name = "updated_at", type = "datetime" },
#   { name = "remember_token_expires_at", type = "datetime" },
#   { name = "is_admin", type = "boolean" },
#   { name = "encrypted_password", type = "string", null = false },
#   { name = "reset_password_token", type = "string" },
#   { name = "remember_created_at", type = "datetime" },
#   { name = "sign_in_count", type = "integer", default = "0" },
#   { name = "current_sign_in_at", type = "datetime" },
#   { name = "last_sign_in_at", type = "datetime" },
#   { name = "current_sign_in_ip", type = "string" },
#   { name = "last_sign_in_ip", type = "string" },
#   { name = "is_verified", type = "boolean", null = false, default = "false" },
#   { name = "opted_in", type = "boolean", default = "false" },
#   { name = "reset_password_sent_at", type = "datetime" },
#   { name = "biography", type = "text" },
#   { name = "photo_uri", type = "string" },
#   { name = "instagram", type = "string" },
#   { name = "mastodon", type = "string" },
#   { name = "bluesky", type = "string" },
#   { name = "linkedin", type = "string" },
#   { name = "twitter", type = "string" },
#   { name = "facebook", type = "string" },
#   { name = "title", type = "string" },
#   { name = "provider", type = "string" },
#   { name = "uid", type = "string" },
#   { name = "token", type = "string" },
#   { name = "refresh_token", type = "string" },
#   { name = "expires_at", type = "datetime" }
# ]
#
# indexes = [
#   { name = "index_users_on_email", columns = ["email"], unique = true },
#   { name = "index_users_on_provider_and_uid", columns = ["provider", "uid"] },
#   { name = "index_users_on_reset_password_token", columns = ["reset_password_token"], unique = true },
#   { name = "index_users_on_username", columns = ["username"], unique = true }
# ]
#
# [polymorphic]
# targets = [{ name = "google_analytics", as = "record" }]
#
# [callbacks]
# before_validation = [{ method = "downcase_keys" }, { method = "strip_whitespace" }]
# before_update = [{ method = "clear_reset_password_token", if = ["clear_reset_password_token?"] }]
# after_update = [{ method = "send_password_change_notification", if = ["send_password_change_notification?"] }, { method = "send_email_changed_notification", if = ["send_email_changed_notification?"] }]
#
# notes = ["todo_item_id:INDEX", "todo_item_id:FK_CONSTRAINT", "google_analytics:N_PLUS_ONE", "username:NOT_NULL", "name:NOT_NULL", "email:NOT_NULL", "crypted_password:NOT_NULL", "salt:NOT_NULL", "is_admin:NOT_NULL", "reset_password_token:NOT_NULL", "sign_in_count:NOT_NULL", "current_sign_in_ip:NOT_NULL", "opted_in:NOT_NULL", "biography:NOT_NULL", "photo_uri:NOT_NULL", "instagram:NOT_NULL", "mastodon:NOT_NULL", "bluesky:NOT_NULL", "linkedin:NOT_NULL", "twitter:NOT_NULL", "facebook:NOT_NULL", "title:NOT_NULL", "provider:NOT_NULL", "uid:NOT_NULL", "token:NOT_NULL", "refresh_token:NOT_NULL", "is_admin:DEFAULT", "photo_uri:LIMIT", "instagram:LIMIT", "mastodon:LIMIT", "bluesky:LIMIT", "linkedin:LIMIT", "twitter:LIMIT", "facebook:LIMIT", "title:LIMIT", "provider:LIMIT", "uid:LIMIT", "token:LIMIT", "refresh_token:LIMIT", "remember_token_expires_at:INDEX", "token:INDEX", "refresh_token:INDEX", "biography:STORAGE"]
# <rails-lens:schema:end>


# A registered user of the website
class User < ApplicationRecord
  belongs_to :todo_item, optional: true
  devise :database_authenticatable, :masqueradable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [ :google_oauth2 ]
  validates_presence_of :username
  validates_length_of :username, within: 3..40
  validates_uniqueness_of :username
  scope :admins, -> {  where(is_admin: true).order(name: :asc) }

  def main_photo
    photo_uri || "team/team-4.jpg"
  end
end
