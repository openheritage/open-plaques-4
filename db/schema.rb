# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_08_095049) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "areas", id: :serial, force: :cascade do |t|
    t.integer "country_id"
    t.datetime "created_at", precision: nil
    t.string "dbpedia_uri", limit: 255
    t.float "latitude"
    t.float "longitude"
    t.float "max_latitude"
    t.float "max_longitude"
    t.float "min_latitude"
    t.float "min_longitude"
    t.string "name", limit: 255
    t.integer "plaques_count"
    t.string "slug", limit: 255
    t.datetime "updated_at", precision: nil
    t.index ["country_id"], name: "index_areas_on_country_id"
    t.index ["name"], name: "index_areas_on_name"
    t.index ["slug"], name: "index_areas_on_slug"
  end

  create_table "colours", id: :serial, force: :cascade do |t|
    t.boolean "common", default: false, null: false
    t.datetime "created_at", precision: nil
    t.string "dbpedia_uri", limit: 255
    t.string "name", limit: 255
    t.integer "plaques_count"
    t.string "slug", limit: 255
    t.datetime "updated_at", precision: nil
    t.index ["slug"], name: "index_colours_on_slug"
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "alpha2", limit: 255
    t.integer "areas_count"
    t.datetime "created_at", precision: nil
    t.text "description"
    t.float "latitude"
    t.float "longitude"
    t.float "max_latitude"
    t.float "max_longitude"
    t.float "min_latitude"
    t.float "min_longitude"
    t.string "name", limit: 255
    t.integer "plaques_count"
    t.integer "preferred_zoom_level"
    t.datetime "updated_at", precision: nil
    t.string "wikidata_id"
  end

  create_table "google_analytics", force: :cascade do |t|
    t.float "average_time_on_page"
    t.float "bounce_rate"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "entrances"
    t.float "exit_percentage"
    t.string "page", null: false
    t.bigint "page_views", null: false
    t.string "period", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.bigint "unique_page_views"
    t.index ["record_type", "record_id", "page", "period"], name: "index_ga_uniqueness", unique: true
  end

  create_table "languages", id: :serial, force: :cascade do |t|
    t.string "alpha2", limit: 255
    t.datetime "created_at", precision: nil
    t.float "latitude"
    t.float "longitude"
    t.float "max_latitude"
    t.float "max_longitude"
    t.float "min_latitude"
    t.float "min_longitude"
    t.string "name", limit: 255
    t.integer "plaques_count"
    t.datetime "updated_at", precision: nil
  end

  create_table "licences", id: :serial, force: :cascade do |t|
    t.string "abbreviation", limit: 255
    t.boolean "allows_commercial_use"
    t.datetime "created_at", precision: nil
    t.string "name", limit: 255
    t.integer "photos_count"
    t.datetime "updated_at", precision: nil
    t.string "url", limit: 255
  end

  create_table "organisations", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.string "en_wikipedia_url"
    t.integer "language_id"
    t.float "latitude"
    t.float "longitude"
    t.float "max_latitude"
    t.float "max_longitude"
    t.float "min_latitude"
    t.float "min_longitude"
    t.string "name", limit: 255
    t.text "notes"
    t.string "slug", limit: 255
    t.integer "sponsorships_count", default: 0
    t.datetime "updated_at", precision: nil
    t.string "website", limit: 255
    t.string "wikidata_id"
    t.index ["name"], name: "index_organisations_on_name"
    t.index ["slug"], name: "index_organisations_on_slug"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.text "abstract"
    t.bigint "author_id"
    t.text "body"
    t.datetime "created_at", precision: nil
    t.float "latitude"
    t.float "longitude"
    t.float "max_latitude"
    t.float "max_longitude"
    t.float "min_latitude"
    t.float "min_longitude"
    t.string "name", limit: 255
    t.string "slug", limit: 255
    t.string "strapline", limit: 255
    t.datetime "updated_at", precision: nil
    t.index ["author_id"], name: "index_pages_on_author_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.text "aka", default: [], array: true
    t.string "ancestry_id", limit: 255
    t.date "born_on"
    t.boolean "born_on_is_circa"
    t.string "citation"
    t.datetime "created_at", precision: nil
    t.date "died_on"
    t.boolean "died_on_is_circa"
    t.string "en_wikipedia_url"
    t.string "ethnicity"
    t.string "find_a_grave_id", limit: 255
    t.string "gender", limit: 255, default: "u"
    t.string "index", limit: 255
    t.text "introduction"
    t.float "latitude"
    t.float "longitude"
    t.float "max_latitude"
    t.float "max_longitude"
    t.float "min_latitude"
    t.float "min_longitude"
    t.string "name", limit: 255
    t.integer "personal_connections_count"
    t.integer "personal_roles_count"
    t.string "surname_starts_with", limit: 255
    t.datetime "updated_at", precision: nil
    t.string "wikidata_id"
    t.index ["born_on", "died_on"], name: "born_and_died"
    t.index ["index"], name: "index_people_on_index"
    t.index ["surname_starts_with"], name: "index_people_on_surname_starts_with"
  end

  create_table "personal_connections", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "ended_at", precision: nil
    t.integer "person_id"
    t.integer "plaque_connections_count"
    t.integer "plaque_id"
    t.datetime "started_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "verb_id"
    t.index ["person_id"], name: "index_personal_connections_on_person_id"
    t.index ["plaque_id"], name: "index_personal_connections_on_plaque_id"
    t.index ["verb_id"], name: "index_personal_connections_on_verb_id"
  end

  create_table "personal_roles", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.date "ended_at"
    t.integer "ordinal"
    t.integer "person_id"
    t.boolean "primary"
    t.integer "related_person_id"
    t.integer "role_id"
    t.date "started_at"
    t.datetime "updated_at", precision: nil
    t.index ["person_id"], name: "index_personal_roles_on_person_id"
    t.index ["related_person_id"], name: "index_personal_roles_on_related_person_id"
    t.index ["role_id"], name: "index_personal_roles_on_role_id"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.integer "clone_id"
    t.datetime "created_at", precision: nil
    t.text "description"
    t.integer "distance_to_nearest_plaque"
    t.string "file_url", limit: 255
    t.string "latitude", limit: 255
    t.integer "licence_id"
    t.string "longitude", limit: 255
    t.integer "nearest_plaque_id"
    t.boolean "of_a_plaque", default: true
    t.integer "person_id"
    t.string "photographer", limit: 255
    t.string "photographer_url", limit: 255
    t.integer "plaque_id"
    t.string "shot", limit: 255
    t.string "subject", limit: 255
    t.datetime "taken_at", precision: nil
    t.string "thumbnail", limit: 255
    t.datetime "updated_at", precision: nil
    t.string "url", limit: 255
    t.index ["licence_id"], name: "index_photos_on_licence_id"
    t.index ["person_id"], name: "index_photos_on_person_id"
    t.index ["photographer"], name: "index_photos_on_photographer"
    t.index ["plaque_id"], name: "index_photos_on_plaque_id"
  end

  create_table "plaques", id: :serial, force: :cascade do |t|
    t.string "address", limit: 255
    t.integer "area_id"
    t.integer "colour_id"
    t.datetime "created_at", precision: nil
    t.text "description"
    t.date "erected_at"
    t.text "inscription"
    t.text "inscription_in_english"
    t.boolean "inscription_is_stub", default: false
    t.boolean "is_accurate_geolocation", default: true
    t.boolean "is_current", default: true
    t.integer "language_id"
    t.float "latitude"
    t.float "longitude"
    t.text "notes"
    t.string "openstreetmap"
    t.text "parsed_inscription"
    t.integer "personal_connections_count", default: 0
    t.integer "photos_count", default: 0, null: false
    t.string "reference", limit: 255
    t.integer "series_id"
    t.string "series_ref", limit: 255
    t.datetime "updated_at", precision: nil
    t.index ["area_id"], name: "index_plaques_on_area_id"
    t.index ["colour_id"], name: "index_plaques_on_colour_id"
    t.index ["latitude", "longitude"], name: "geo"
    t.index ["series_id"], name: "index_plaques_on_series_id"
  end

  create_table "railspress_agent_bootstrap_keys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "created_by_type"
    t.bigint "exchanged_api_key_id"
    t.datetime "expires_at", null: false
    t.string "global_uuid", null: false
    t.string "name", null: false
    t.bigint "owner_id"
    t.string "owner_type"
    t.string "revoke_reason"
    t.datetime "revoked_at"
    t.bigint "revoked_by_id"
    t.string "revoked_by_type"
    t.text "secret_ciphertext", null: false
    t.string "token_digest", null: false
    t.string "token_prefix", null: false
    t.datetime "updated_at", null: false
    t.datetime "used_at"
    t.string "used_ip"
    t.index ["created_by_type", "created_by_id"], name: "idx_rp_agent_bootstrap_keys_created_by"
    t.index ["exchanged_api_key_id"], name: "index_railspress_agent_bootstrap_keys_on_exchanged_api_key_id"
    t.index ["global_uuid"], name: "index_railspress_agent_bootstrap_keys_on_global_uuid", unique: true
    t.index ["owner_type", "owner_id"], name: "idx_rp_agent_bootstrap_keys_owner"
    t.index ["revoked_by_type", "revoked_by_id"], name: "idx_rp_agent_bootstrap_keys_revoked_by"
    t.index ["token_digest"], name: "index_railspress_agent_bootstrap_keys_on_token_digest", unique: true
    t.index ["token_prefix"], name: "index_railspress_agent_bootstrap_keys_on_token_prefix"
  end

  create_table "railspress_api_keys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "created_by_type"
    t.datetime "expires_at"
    t.string "global_uuid", null: false
    t.datetime "last_used_at"
    t.string "last_used_ip"
    t.string "name", null: false
    t.bigint "owner_id"
    t.string "owner_type"
    t.string "revoke_reason"
    t.datetime "revoked_at"
    t.bigint "revoked_by_id"
    t.string "revoked_by_type"
    t.bigint "rotated_by_id"
    t.string "rotated_by_type"
    t.integer "rotated_from_id"
    t.text "secret_ciphertext", null: false
    t.string "token_digest", null: false
    t.string "token_prefix", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_type", "created_by_id"], name: "index_railspress_api_keys_on_created_by_type_and_created_by_id"
    t.index ["global_uuid"], name: "index_railspress_api_keys_on_global_uuid", unique: true
    t.index ["owner_type", "owner_id"], name: "index_railspress_api_keys_on_owner_type_and_owner_id"
    t.index ["revoked_by_type", "revoked_by_id"], name: "index_railspress_api_keys_on_revoked_by_type_and_revoked_by_id"
    t.index ["rotated_by_type", "rotated_by_id"], name: "index_railspress_api_keys_on_rotated_by_type_and_rotated_by_id"
    t.index ["rotated_from_id"], name: "index_railspress_api_keys_on_rotated_from_id"
    t.index ["token_digest"], name: "index_railspress_api_keys_on_token_digest", unique: true
    t.index ["token_prefix"], name: "index_railspress_api_keys_on_token_prefix"
  end

  create_table "railspress_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_railspress_categories_on_name", unique: true
    t.index ["slug"], name: "index_railspress_categories_on_slug", unique: true
  end

  create_table "railspress_content_element_versions", force: :cascade do |t|
    t.bigint "author_id"
    t.bigint "content_element_id", null: false
    t.datetime "created_at", null: false
    t.text "text_content"
    t.datetime "updated_at", null: false
    t.integer "version_number", null: false
    t.index ["author_id"], name: "index_railspress_content_element_versions_on_author_id"
    t.index ["content_element_id", "version_number"], name: "idx_content_element_versions_unique", unique: true
    t.index ["content_element_id"], name: "idx_on_content_element_id_c4c667c695"
  end

  create_table "railspress_content_elements", force: :cascade do |t|
    t.bigint "author_id"
    t.bigint "content_group_id", null: false
    t.integer "content_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "image_hint"
    t.string "name", null: false
    t.integer "position"
    t.boolean "required", default: false, null: false
    t.text "text_content"
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_railspress_content_elements_on_author_id"
    t.index ["content_group_id", "name"], name: "idx_content_elements_unique_name_per_group", unique: true, where: "(deleted_at IS NULL)"
    t.index ["content_group_id"], name: "index_railspress_content_elements_on_content_group_id"
    t.index ["content_type"], name: "index_railspress_content_elements_on_content_type"
    t.index ["deleted_at"], name: "index_railspress_content_elements_on_deleted_at"
  end

  create_table "railspress_content_groups", force: :cascade do |t|
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_railspress_content_groups_on_author_id"
    t.index ["deleted_at"], name: "index_railspress_content_groups_on_deleted_at"
    t.index ["name"], name: "index_railspress_content_groups_on_name", unique: true
  end

  create_table "railspress_exports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "error_count", default: 0
    t.text "error_messages"
    t.string "export_type", null: false
    t.string "filename"
    t.string "status", default: "pending", null: false
    t.integer "success_count", default: 0
    t.integer "total_count", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["export_type"], name: "index_railspress_exports_on_export_type"
    t.index ["status"], name: "index_railspress_exports_on_status"
    t.index ["user_id"], name: "index_railspress_exports_on_user_id"
  end

  create_table "railspress_focal_points", force: :cascade do |t|
    t.string "attachment_name", null: false
    t.datetime "created_at", null: false
    t.decimal "focal_x", precision: 5, scale: 4, default: "0.5", null: false
    t.decimal "focal_y", precision: 5, scale: 4, default: "0.5", null: false
    t.json "overrides", default: {}
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "attachment_name"], name: "idx_focal_points_record_attachment", unique: true
  end

  create_table "railspress_imports", force: :cascade do |t|
    t.string "content_type"
    t.datetime "created_at", null: false
    t.integer "error_count", default: 0
    t.text "error_messages"
    t.string "filename"
    t.string "import_type", null: false
    t.string "status", default: "pending", null: false
    t.integer "success_count", default: 0
    t.integer "total_count", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["import_type"], name: "index_railspress_imports_on_import_type"
    t.index ["status"], name: "index_railspress_imports_on_status"
    t.index ["user_id"], name: "index_railspress_imports_on_user_id"
  end

  create_table "railspress_posts", force: :cascade do |t|
    t.bigint "author_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.text "meta_description"
    t.string "meta_title"
    t.datetime "published_at"
    t.integer "reading_time"
    t.string "slug", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_railspress_posts_on_author_id"
    t.index ["category_id"], name: "index_railspress_posts_on_category_id"
    t.index ["published_at"], name: "index_railspress_posts_on_published_at"
    t.index ["slug"], name: "index_railspress_posts_on_slug", unique: true
    t.index ["status"], name: "index_railspress_posts_on_status"
  end

  create_table "railspress_taggings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "tag_id", null: false
    t.bigint "taggable_id", null: false
    t.string "taggable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id", "taggable_type", "taggable_id"], name: "index_taggings_unique", unique: true
    t.index ["tag_id"], name: "index_railspress_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_railspress_taggings_on_taggable"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable"
  end

  create_table "railspress_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_railspress_tags_on_name", unique: true
    t.index ["slug"], name: "index_railspress_tags_on_slug", unique: true
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "abbreviation", limit: 255
    t.datetime "created_at", precision: nil
    t.text "description"
    t.string "en_wikipedia_url"
    t.string "index", limit: 255
    t.string "name", limit: 255
    t.integer "personal_roles_count"
    t.string "prefix", limit: 255
    t.integer "priority"
    t.string "role_type", limit: 255
    t.string "slug", limit: 255
    t.string "suffix", limit: 255
    t.datetime "updated_at", precision: nil
    t.string "wikidata_id"
    t.index ["index"], name: "starts_with"
    t.index ["role_type"], name: "index_roles_on_role_type"
    t.index ["slug"], name: "index_roles_on_slug"
  end

  create_table "series", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "description", limit: 255
    t.float "latitude"
    t.float "longitude"
    t.float "max_latitude"
    t.float "max_longitude"
    t.float "min_latitude"
    t.float "min_longitude"
    t.string "name", limit: 255
    t.integer "plaques_count"
    t.datetime "updated_at", precision: nil
  end

  create_table "sponsorships", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "organisation_id"
    t.integer "plaque_id"
    t.datetime "updated_at", precision: nil
    t.index ["organisation_id"], name: "index_sponsorships_on_organisation_id"
    t.index ["plaque_id"], name: "index_sponsorships_on_plaque_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "todo_items", id: :serial, force: :cascade do |t|
    t.string "action", limit: 255
    t.datetime "created_at", precision: nil
    t.text "description"
    t.string "image_url", limit: 255
    t.string "name"
    t.integer "plaque_id"
    t.datetime "updated_at", precision: nil
    t.text "url"
    t.integer "user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.text "biography"
    t.string "bluesky"
    t.datetime "created_at", precision: nil
    t.string "crypted_password", limit: 40
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "email", limit: 100
    t.string "encrypted_password", limit: 128, null: false
    t.datetime "expires_at"
    t.string "facebook"
    t.string "instagram"
    t.boolean "is_admin"
    t.boolean "is_verified", default: false, null: false
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip", limit: 255
    t.string "linkedin"
    t.string "mastodon"
    t.string "name", limit: 100
    t.boolean "opted_in", default: false
    t.string "photo_uri"
    t.string "provider"
    t.string "refresh_token"
    t.datetime "remember_created_at", precision: nil
    t.datetime "remember_token_expires_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token", limit: 255
    t.string "salt", limit: 40
    t.integer "sign_in_count", default: 0
    t.string "title"
    t.string "token"
    t.string "twitter"
    t.string "uid"
    t.datetime "updated_at", precision: nil
    t.string "username", limit: 40
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "verbs", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "name", limit: 255
    t.integer "personal_connections_count"
    t.datetime "updated_at", precision: nil
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "pages", "users", column: "author_id"
  add_foreign_key "railspress_content_element_versions", "railspress_content_elements", column: "content_element_id"
  add_foreign_key "railspress_content_elements", "railspress_content_groups", column: "content_group_id"
  add_foreign_key "railspress_posts", "railspress_categories", column: "category_id"
  add_foreign_key "railspress_taggings", "railspress_tags", column: "tag_id"
end
