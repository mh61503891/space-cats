class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.text :body
      t.timestamps
    end
    create_table :note_contents do |t|
      t.references :note, null: false, foreign_key: true
      t.references :content, null: false, foreign_key: true
      t.timestamps
    end
    create_table :note_keywords do |t|
      t.references :note, null: false, foreign_key: true
      t.references :keyword, null: false, foreign_key: true
      t.timestamps
    end
  end
end
