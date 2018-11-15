class InitSchema < ActiveRecord::Migration[5.2]
  def change

    create_table :settings do |t|
      t.text :data
      t.timestamps null: false
    end

    create_table :contents do |t|
      t.string :url
      t.string :open_graph_title
      t.string :open_graph_type
      t.string :open_graph_url
      t.binary :open_graph_image_content, limit: 1024.megabytes
      t.string :open_graph_image_url
      t.string :open_graph_description
      t.string :open_graph_site_name
      t.timestamps null: false
    end
    add_index :contents, :url, unique: true

  end
end
