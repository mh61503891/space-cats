class InitSchema < ActiveRecord::Migration[5.2]
  def change

    # Settings
    create_table :settings do |t|
      t.text :data
      t.timestamps null: false
    end

    # Contents
    # https://developers.facebook.com/docs/reference/opengraph/object-type/website/
    # https://developers.facebook.com/docs/sharing/opengraph/object-properties?locale=ja_JP
    create_table :contents do |t|
      # The type of a content
      t.integer :media_type, null: false
      # URLs
      t.string :url, null: false
      t.string :canonical_url, null: false
      # Metadata
      # @see http://ogp.me/
      t.string :og_title
      t.string :og_type
      t.string :og_author
      t.string :og_image
      t.string :og_url
      t.text :og_description
      t.string :og_site_name
      # Data
      t.references :data, foreign_key: { to_table: :blobs }
      t.references :abstract_data, foreign_key: { to_table: :blobs }
      # Statistics
      t.integer :input_count, null: false, default: 1
      t.integer :output_count, null: false, default: 0
      # Timestamps
      t.timestamps null: false
    end
    %i[
      media_type
      og_title
      og_type
      og_author
      og_image
      og_url
      og_description
      og_site_name
      input_count
      output_count
      created_at
      updated_at
    ].each do |column|
      add_index :contents, column
    end
    add_index :contents, :url, unique: true
    add_index :contents, :canonical_url, unique: true

    # Blobs
    create_table :blobs do |t|
      # Properties
      t.string :filename
      t.string :content_type
      t.bigint :byte_size, null: false
      t.string :checksum, null: false
      t.binary :data, limit: 1024.megabytes, null: false
      # Timestamps
      t.timestamps null: false
    end
    %i[
      filename
      content_type
      byte_size
      created_at
      updated_at
    ].each do |column|
      add_index :blobs, column
    end
    add_index :blobs, :checksum, unique: true

  end
end
