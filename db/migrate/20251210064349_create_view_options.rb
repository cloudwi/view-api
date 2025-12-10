class CreateViewOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :view_options do |t|
      t.references :view, null: false, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
