class CreateVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :view_option, null: false, foreign_key: true

      t.timestamps
    end

    add_index :votes, [ :user_id, :view_option_id ], unique: true
  end
end
