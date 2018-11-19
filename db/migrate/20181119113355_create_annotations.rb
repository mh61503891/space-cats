class CreateAnnotations < ActiveRecord::Migration[5.2]
  def change

    create_table :keywords do |t|
      t.string :ancestry
      t.string :name, null: false
      t.timestamps null: false
    end
    %i[
      ancestry
      created_at
      updated_at
    ].each do |column|
      add_index :keywords, column
    end
    add_index :keywords, :name ,unique: true

    create_table :content_keywords do |t|
      t.references :content, foreign_key: true
      t.references :keyword, foreign_key: true
      t.timestamps null: false, index: true
    end
    add_index :content_keywords, [:content_id, :keyword_id] ,unique: true

  end
end
