class CreateListItems < ActiveRecord::Migration[7.0]
  def change
    create_table :list_items do |t|
      t.string :description
      t.boolean :done, default: false, null: false
      t.references :todo_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
