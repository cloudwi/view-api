class AddCommentsCountToViews < ActiveRecord::Migration[8.1]
  def change
    add_column :views, :comments_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up do
        # 기존 뷰들의 comments_count를 올바른 값으로 초기화
        View.find_each do |view|
          View.reset_counters(view.id, :comments)
        end
      end
    end
  end
end
