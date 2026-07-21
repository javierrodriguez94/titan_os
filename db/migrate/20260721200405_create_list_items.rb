class CreateListItems < ActiveRecord::Migration[8.1]
  def change
    create_table :list_items do |t|
      t.references :list, null: false, foreign_key: true, index: false
      t.references :content, polymorphic: true, null: false
      t.integer :position, null: false

      t.timestamps
    end

    add_index :list_items, [ :list_id, :position ], unique: true
    add_index :list_items, [ :list_id, :content_type, :content_id ], unique: true, name: "index_list_items_on_list_and_content"
  end
end
