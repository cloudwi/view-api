class AddCategoryIdToViews < ActiveRecord::Migration[8.1]
  def change
    # 기존 enum category 컬럼 제거
    remove_index :views, :category if index_exists?(:views, :category)
    remove_column :views, :category, :integer

    # 새로운 category_id 참조 추가
    add_reference :views, :category, null: false, foreign_key: true
  end
end
