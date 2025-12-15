class AddCategoryToViews < ActiveRecord::Migration[8.1]
  def change
    add_column :views, :category, :integer, default: 0, null: false
    add_index :views, :category
  end
end
