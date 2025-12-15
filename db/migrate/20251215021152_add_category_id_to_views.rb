class AddCategoryIdToViews < ActiveRecord::Migration[8.1]
  def up
    # 기존 enum category 컬럼 제거
    remove_index :views, :category if index_exists?(:views, :category)
    remove_column :views, :category, :integer

    # 1. nullable로 category_id 추가
    add_reference :views, :category, null: true, foreign_key: true

    # 2. 기본 카테고리 생성 (존재하지 않는 경우)
    default_category = Category.find_or_create_by!(slug: 'etc') do |c|
      c.name = '기타'
      c.description = '기타 카테고리'
      c.display_order = 999
    end

    # 3. 기존 views에 기본 카테고리 할당
    View.where(category_id: nil).update_all(category_id: default_category.id)

    # 4. null 제약 조건 추가
    change_column_null :views, :category_id, false
  end

  def down
    # category_id 컬럼 제거
    remove_reference :views, :category, foreign_key: true

    # 기존 enum category 컬럼 복원
    add_column :views, :category, :integer, default: 0, null: false
    add_index :views, :category
  end
end
