class AddVotesCountToViewOptions < ActiveRecord::Migration[8.1]
  def change
    add_column :view_options, :votes_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up do
        # 기존 view_options의 votes_count를 올바른 값으로 초기화
        ViewOption.find_each do |view_option|
          ViewOption.reset_counters(view_option.id, :votes)
        end
      end
    end
  end
end
