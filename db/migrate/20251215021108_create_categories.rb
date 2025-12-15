class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :description
      t.string :icon
      t.integer :display_order, default: 0, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :categories, :slug, unique: true
    add_index :categories, :display_order
    add_index :categories, :active
  end
end
