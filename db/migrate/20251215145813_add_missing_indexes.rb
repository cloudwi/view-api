class AddMissingIndexes < ActiveRecord::Migration[8.1]
  def change
    # 댓글 정렬을 위한 인덱스
    add_index :comments, :created_at

    # hot 정렬과 필터링을 위한 인덱스
    add_index :views, :comments_count

    # 선택지 정렬을 위한 인덱스
    add_index :view_options, :votes_count

    # 복합 인덱스: view_id + created_at (뷰별 댓글 조회 최적화)
    add_index :comments, [ :view_id, :created_at ]
  end
end
