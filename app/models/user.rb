# A registered user of the website
# === Attributes
# * +username+ - unique identifier
# * +name+ - full name
# * +email+ - e-mail address
# * +crypted_password+ - [used by Devise]
# * +salt+ - [used by Devise]
# * +created_at+
# * +updated_at+
# * +remember_token_expires_at+ - [used by Devise]
# * +is_admin+ - whether they have superpowers
# * +encrypted_password+ - [used by Devise]
# * +reset_password_token+ - [used by Devise]
# * +remember_created_at+ - [used by Devise]
# * +sign_in_count+ - [used by Devise]
# * +current_sign_in_at+ - [used by Devise]
# * +last_sign_in_at+ - [used by Devise]
# * +current_sign_in_ip+ - [used by Devise]
# * +last_sign_in_ip+ - [used by Devise]
# * +is_verified+ - [used by Devise]
# * +opted_in+ - [used by Devise]
# * +reset_password_sent_at+ - [used by Devise]
class User < ApplicationRecord
  belongs_to :todo_item, optional: true
  devise :database_authenticatable, :masqueradable, :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :username
  validates_length_of :username, within: 3..40
  validates_uniqueness_of :username
end
