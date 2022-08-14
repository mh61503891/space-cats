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

ActiveRecord::Schema[7.0].define(version: 2022_08_14_141045) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.integer "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blobs", force: :cascade do |t|
    t.string "filename"
    t.string "content_type"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.binary "data", limit: 1073741824, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["byte_size"], name: "index_blobs_on_byte_size"
    t.index ["checksum"], name: "index_blobs_on_checksum", unique: true
    t.index ["content_type"], name: "index_blobs_on_content_type"
    t.index ["created_at"], name: "index_blobs_on_created_at"
    t.index ["filename"], name: "index_blobs_on_filename"
    t.index ["updated_at"], name: "index_blobs_on_updated_at"
  end

  create_table "content_keywords", force: :cascade do |t|
    t.integer "content_id"
    t.integer "keyword_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["content_id", "keyword_id"], name: "index_content_keywords_on_content_id_and_keyword_id", unique: true
    t.index ["content_id"], name: "index_content_keywords_on_content_id"
    t.index ["created_at"], name: "index_content_keywords_on_created_at"
    t.index ["keyword_id"], name: "index_content_keywords_on_keyword_id"
    t.index ["updated_at"], name: "index_content_keywords_on_updated_at"
  end

  create_table "contents", force: :cascade do |t|
    t.integer "media_type", default: 0, null: false
    t.string "url", null: false
    t.string "canonical_url", null: false
    t.string "og_title"
    t.string "og_type"
    t.string "og_author"
    t.string "og_image"
    t.string "og_url"
    t.text "og_description"
    t.string "og_site_name"
    t.integer "data_id"
    t.integer "abstract_data_id"
    t.integer "input_count", default: 1, null: false
    t.integer "output_count", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["abstract_data_id"], name: "index_contents_on_abstract_data_id"
    t.index ["canonical_url"], name: "index_contents_on_canonical_url", unique: true
    t.index ["created_at"], name: "index_contents_on_created_at"
    t.index ["data_id"], name: "index_contents_on_data_id"
    t.index ["input_count"], name: "index_contents_on_input_count"
    t.index ["media_type"], name: "index_contents_on_media_type"
    t.index ["og_author"], name: "index_contents_on_og_author"
    t.index ["og_description"], name: "index_contents_on_og_description"
    t.index ["og_image"], name: "index_contents_on_og_image"
    t.index ["og_site_name"], name: "index_contents_on_og_site_name"
    t.index ["og_title"], name: "index_contents_on_og_title"
    t.index ["og_type"], name: "index_contents_on_og_type"
    t.index ["og_url"], name: "index_contents_on_og_url"
    t.index ["output_count"], name: "index_contents_on_output_count"
    t.index ["updated_at"], name: "index_contents_on_updated_at"
    t.index ["url"], name: "index_contents_on_url", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "ancestry"
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ancestry"], name: "index_keywords_on_ancestry"
    t.index ["created_at"], name: "index_keywords_on_created_at"
    t.index ["name"], name: "index_keywords_on_name", unique: true
    t.index ["updated_at"], name: "index_keywords_on_updated_at"
  end

  create_table "note_contents", force: :cascade do |t|
    t.integer "note_id", null: false
    t.integer "content_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_note_contents_on_content_id"
    t.index ["note_id"], name: "index_note_contents_on_note_id"
  end

  create_table "note_keywords", force: :cascade do |t|
    t.integer "note_id", null: false
    t.integer "keyword_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_note_keywords_on_keyword_id"
    t.index ["note_id"], name: "index_note_keywords_on_note_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.text "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "content_keywords", "contents"
  add_foreign_key "content_keywords", "keywords"
  add_foreign_key "contents", "blobs", column: "abstract_data_id"
  add_foreign_key "contents", "blobs", column: "data_id"
  add_foreign_key "note_contents", "contents"
  add_foreign_key "note_contents", "notes"
  add_foreign_key "note_keywords", "keywords"
  add_foreign_key "note_keywords", "notes"
end
