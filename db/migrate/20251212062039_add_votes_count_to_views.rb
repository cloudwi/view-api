class AddVotesCountToViews < ActiveRecord::Migration[8.1]
  def change
    add_column :views, :votes_count, :integer, default: 0, null: false

    # 검색 및 정렬을 위한 인덱스
    add_index :views, :created_at
    add_index :views, :votes_count
    add_index :views, :title
  end
end
