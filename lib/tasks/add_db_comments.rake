# frozen_string_literal: true

namespace :db do
  desc "데이터베이스 테이블 및 컬럼에 주석 추가"
  task add_comments: :environment do
    puts "🔄 데이터베이스 주석 추가 시작..."

    connection = ActiveRecord::Base.connection

    # users 테이블
    connection.execute("COMMENT ON TABLE users IS '사용자'")
    connection.execute("COMMENT ON COLUMN users.id IS '사용자 ID (PK)'")
    connection.execute("COMMENT ON COLUMN users.email IS '이메일 주소'")
    connection.execute("COMMENT ON COLUMN users.encrypted_password IS '암호화된 비밀번호'")
    connection.execute("COMMENT ON COLUMN users.name IS '사용자 이름'")
    connection.execute("COMMENT ON COLUMN users.nickname IS '자동 생성되는 닉네임 (고유)'")
    connection.execute("COMMENT ON COLUMN users.profile_image IS '프로필 이미지 URL'")
    connection.execute("COMMENT ON COLUMN users.provider IS 'OAuth 제공자 (kakao 등)'")
    connection.execute("COMMENT ON COLUMN users.uid IS 'OAuth 제공자의 사용자 ID'")
    connection.execute("COMMENT ON COLUMN users.remember_created_at IS '로그인 기억 생성 시각'")
    connection.execute("COMMENT ON COLUMN users.reset_password_sent_at IS '비밀번호 재설정 메일 발송 시각'")
    connection.execute("COMMENT ON COLUMN users.reset_password_token IS '비밀번호 재설정 토큰'")
    connection.execute("COMMENT ON COLUMN users.created_at IS '생성 시각'")
    connection.execute("COMMENT ON COLUMN users.updated_at IS '수정 시각'")
    puts "  ✓ users 테이블 주석 추가 완료"

    # categories 테이블
    connection.execute("COMMENT ON TABLE categories IS '카테고리'")
    connection.execute("COMMENT ON COLUMN categories.id IS '카테고리 ID (PK)'")
    connection.execute("COMMENT ON COLUMN categories.name IS '카테고리 이름'")
    connection.execute("COMMENT ON COLUMN categories.slug IS '카테고리 슬러그 (URL용, 고유)'")
    connection.execute("COMMENT ON COLUMN categories.description IS '카테고리 설명'")
    connection.execute("COMMENT ON COLUMN categories.icon IS '카테고리 아이콘 (이모지)'")
    connection.execute("COMMENT ON COLUMN categories.display_order IS '표시 순서 (오름차순)'")
    connection.execute("COMMENT ON COLUMN categories.active IS '활성화 여부'")
    connection.execute("COMMENT ON COLUMN categories.created_at IS '생성 시각'")
    connection.execute("COMMENT ON COLUMN categories.updated_at IS '수정 시각'")
    puts "  ✓ categories 테이블 주석 추가 완료"

    # views 테이블
    connection.execute("COMMENT ON TABLE views IS '뷰 (의견/질문)'")
    connection.execute("COMMENT ON COLUMN views.id IS '뷰 ID (PK)'")
    connection.execute("COMMENT ON COLUMN views.title IS '뷰(의견) 제목'")
    connection.execute("COMMENT ON COLUMN views.user_id IS '작성자 ID (users.id FK)'")
    connection.execute("COMMENT ON COLUMN views.category_id IS '카테고리 ID (categories.id FK)'")
    connection.execute("COMMENT ON COLUMN views.votes_count IS '총 투표 수 (카운터 캐시)'")
    connection.execute("COMMENT ON COLUMN views.comments_count IS '총 댓글 수 (카운터 캐시)'")
    connection.execute("COMMENT ON COLUMN views.created_at IS '생성 시각'")
    connection.execute("COMMENT ON COLUMN views.updated_at IS '수정 시각'")
    puts "  ✓ views 테이블 주석 추가 완료"

    # view_options 테이블
    connection.execute("COMMENT ON TABLE view_options IS '뷰 선택지'")
    connection.execute("COMMENT ON COLUMN view_options.id IS '선택지 ID (PK)'")
    connection.execute("COMMENT ON COLUMN view_options.content IS '선택지 내용'")
    connection.execute("COMMENT ON COLUMN view_options.view_id IS '뷰 ID (views.id FK)'")
    connection.execute("COMMENT ON COLUMN view_options.votes_count IS '투표 수 (카운터 캐시)'")
    connection.execute("COMMENT ON COLUMN view_options.created_at IS '생성 시각'")
    connection.execute("COMMENT ON COLUMN view_options.updated_at IS '수정 시각'")
    puts "  ✓ view_options 테이블 주석 추가 완료"

    # votes 테이블
    connection.execute("COMMENT ON TABLE votes IS '투표'")
    connection.execute("COMMENT ON COLUMN votes.id IS '투표 ID (PK)'")
    connection.execute("COMMENT ON COLUMN votes.user_id IS '투표한 사용자 ID (users.id FK)'")
    connection.execute("COMMENT ON COLUMN votes.view_option_id IS '투표한 선택지 ID (view_options.id FK)'")
    connection.execute("COMMENT ON COLUMN votes.created_at IS '투표 시각'")
    connection.execute("COMMENT ON COLUMN votes.updated_at IS '수정 시각'")
    puts "  ✓ votes 테이블 주석 추가 완료"

    # comments 테이블
    connection.execute("COMMENT ON TABLE comments IS '댓글'")
    connection.execute("COMMENT ON COLUMN comments.id IS '댓글 ID (PK)'")
    connection.execute("COMMENT ON COLUMN comments.content IS '댓글 내용'")
    connection.execute("COMMENT ON COLUMN comments.user_id IS '작성자 ID (users.id FK)'")
    connection.execute("COMMENT ON COLUMN comments.view_id IS '뷰 ID (views.id FK)'")
    connection.execute("COMMENT ON COLUMN comments.created_at IS '작성 시각'")
    connection.execute("COMMENT ON COLUMN comments.updated_at IS '수정 시각'")
    puts "  ✓ comments 테이블 주석 추가 완료"

    puts "\n✅ 모든 테이블 및 컬럼 주석 추가 완료!"
  end
end
